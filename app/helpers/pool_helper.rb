module PoolHelper
  
  # return a html class for this pic for given_round_number.
  def class_for_game_pic(given_round, given_pic, master_pics, pool_user)
    html = "gamePicInRound"
    pic_furthest_round_won_number = given_pic.furthest_round_won_number
    if pic_furthest_round_won_number && pic_furthest_round_won_number >= given_round
      game_in_lineage = given_pic.game.game_in_lineage_with_pic(given_pic, given_round)
      master_pic = master_pics.detect { |p| p.game_id == game_in_lineage.id }
      if master_pic.bid
        if given_pic.bid_id == master_pic.bid_id
          html += "Correct"
        else
          html += "Incorrect"
        end
      else
        html += "Dead" unless pool_user.pics.for_game(game_in_lineage).still_alive?
      end
    end
    html
  end
  
  def scoring_system_select_tag(scoring_system_id)
    select_tag(:scoring_system_id, options_for_select(ScoringSystems::container, scoring_system_id))
  end
  
  def pic_bullet
    content_tag :STRONG, '&bull;'
  end
  
  # render recursive partial for a game.
  def game_partial(game, left_or_right, ancestors_to_include = 0)
    render :partial => 'game',
           :locals => {:game => game,
                       :left_or_right => left_or_right,
                       :ancestors_to_include => ancestors_to_include}
  end
  
  # td cell that spans rows according to game.
  # it's also aligned according to left_or_right
  def game_td(game, left_or_right, &block)
    concat content_tag(:td, capture(&block), :rowspan => (2 ** (game.round.number - 1)), :align => left_or_right), block.binding
  end
  
  # a table that contains each bid as a row.
  def bids_table(bids, game, pool_user, left_or_right)
    cells_for_bids = bids.map do |bid|
      if @printable
        bid_cells(bid, left_or_right)
      else
        bid_for_game bid, game, pool_user, cycle('top', 'bottom', :name => 'top_or_bottom')
      end
    end
    reset_cycle('top_or_bottom') unless @printable
    rows = cells_for_bids.map { |bid_cells| content_tag :tr, bid_cells }
    content_tag(:table, rows, :style => "white-space: nowrap; border-collapse: collapse;")
  end
  
  # seed and a team each wrapped in a <td> tag.
  # put seed on left_or_right side.
  def bid_cells(bid, seed_on_left_or_right)
    options = {:align => seed_on_left_or_right, :style => "border-bottom: 1px solid black; padding-#{seed_on_left_or_right}: 2mm;"}
    seed = content_tag :td, (bid ? "(#{bid.seed})" : '&nbsp'), options
    team = content_tag :td, (bid ? h(bid.team.name) : '&nbsp'), options
    cells = [seed, team]
    cells.reverse! if 'right' == seed_on_left_or_right
    cells
  end
  
  # td tag with 2 bids and the game's pic.
  def game_participants_and_pic(game, pool_user, left_or_right)
    participating_bids_content = bids_table game.participating_bids(pool_user), game, pool_user, left_or_right
    pic_content = bids_table [pool_user.pics.for_game(game).bid], game, pool_user, left_or_right
    cells_content = [participating_bids_content, pic_content]
    cells_content.reverse! if 'right' == left_or_right
    cells_content.map { |content| content_tag(:td, content_tag(:div, content, :style => "float: #{left_or_right};")) }
  end
  
  # turn this into a string or symbol subclass.
  def neg(direction)
    case direction.to_s
    when 'right'
      'left'
    when 'left'
      'right'
    when 'top'
      'bottom'
    when 'bottom'
      'top'
    end
  end
  
  def bid_spinner_dom_id(bid, game)
    dom_id bid, (game.children.empty? ? '' : dom_id(game)) + '_spinner'
  end
  
  def bracket_completion_span(complete)
    content = complete ? 'bracket complete' : 'bracket incomplete'
    content_tag :span, content, :style => "color: #{complete ? 'green' : 'red'}"
  end
  
  # render pic partial, or just bid partial if this is first round game.
  # all wrapped in table cell.
  def bid_for_game(bid, game, pool_user, top_or_bottom)
    pic = pool_user.pics.for_game(game.children.empty? ? game : game.send(top_or_bottom))
    content = if game.children.empty?
      partial = render(:partial => "bid", :locals => {:bid => bid,
                                                      :game => game,
                                                      :pool_user => pool_user,
                                                      :pic => pic})
      content_tag :div, partial, :class => 'firstRoundBid bid', :id => dom_id(bid)
    else
      pic_div(pic, game, pool_user, bid)
    end
    content_tag :td, content
  end
  
  def pic_div(pic, game, pool_user, bid, no_link = false)
    content = render :partial => "pic", :locals => {:pic => pic, :game => game, :pool_user => pool_user, :bid => bid, :no_link => no_link}
    content_tag :div, content, :id => dom_id(pic), :class => 'pic'
  end
  
end
