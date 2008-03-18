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
  
  def printable_game_partial(game, bracket_side, top_or_bottom = nil, ancestors_to_include = 0)
    render :partial => 'printable_game', :locals => {:game => game,
                                                     :top_or_bottom => top_or_bottom,
                                                     :ancestors_to_include => ancestors_to_include,
                                                     :bracket_side => bracket_side}
  end
  
  def game_cell(game, pool_user, left_or_right)
    # bids for top and bottom.
    top_row_participants, bottom_row_content = game.participating_bids(pool_user).map { |bid| bid_cells(bid, left_or_right) }
    top_row_content = [top_row_participants]
    # add championship_game_pic if this is a championship game.
    top_row_content << bid_cells(pool_user.pics.for_game(game).bid, left_or_right, 2) if game.is_championship_game?
    # reverse order if this is right side.
    top_row_content.reverse! if 'right' == left_or_right
    # form into rows.
    rows = [top_row_content.flatten, bottom_row_content].map { |bid_cells| content_tag :tr, bid_cells }
    # put into table.
    bids_table = content_tag(:table, rows, :style => "width: 100%; white-space: nowrap; font-size: 10pt; border-collapse: collapse;")
    # put it all in a single table cell.
    content_tag(:td, bids_table, :rowspan => 2 ** (game.round.number - 1), :align => left_or_right)
  end
  
  def bid_cells(bid, left_or_right, rowspan = nil)
    style = 'border: 1px solid black'
    options = {:align => left_or_right, :style => style}
    options[:rowspan] = rowspan if rowspan
    seed = content_tag :td, bid.seed, options
    team = content_tag :td, bid.team.name, options
    cells = [seed, team]
    cells.reverse! if 'right' == left_or_right
    cells
  end
  
end
