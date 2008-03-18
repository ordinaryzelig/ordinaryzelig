module PoolHelper
  
  # put this here for ajax if needed.
  def region_bracket_partial(region, pool_user)
    render(:partial => "region_bracket", :locals => {:region => region, :pool_user => pool_user})
  end
  
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
  def printable_game_partial(game, bracket_side, top_or_bottom = nil, ancestors_to_include = 0)
    render :partial => 'printable_game', :locals => {:game => game,
                                                     :top_or_bottom => top_or_bottom,
                                                     :ancestors_to_include => ancestors_to_include,
                                                     :bracket_side => bracket_side}
  end
  
  # <table> of top and bottom bids wrapped in a <td> tag.
  def game_cell(game, pool_user, left_or_right, wrap_bids_table_in_opposite_floated_div = false)
    top_bottom_bid_cells = game.participating_bids(pool_user).map { |bid| bid_cells(bid, left_or_right) }
    rows = top_bottom_bid_cells.map { |bid_cells| content_tag :tr, bid_cells }
    bids_table = content_tag(:table, rows, :style => "white-space: nowrap; font-size: 10pt; border-collapse: collapse;")
    bids_table = content_tag :div, bids_table, :style => "float: #{neg(left_or_right)}" if wrap_bids_table_in_opposite_floated_div
    # put it all in a single table cell for outer table.
    content_tag(:td, bids_table, :rowspan => (2 ** (game.round.number - 1)), :align => left_or_right)
  end
  
  # seed and a team each wrapped in a <td> tag.
  # put seed on left_or_right side.
  def bid_cells(bid, left_or_right)
    options = {:align => left_or_right, :style => "border-bottom: 1px solid black; padding-#{left_or_right}: 2mm;"}
    seed = content_tag :td, "(#{bid.seed})", options
    team = content_tag :td, bid.team.name, options
    cells = [seed, team]
    cells.reverse! if 'right' == left_or_right
    cells
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
  
end
