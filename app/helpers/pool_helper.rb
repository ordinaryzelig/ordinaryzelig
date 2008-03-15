module PoolHelper
  
  # put this here for ajax if needed.
  def region_bracket_partial(region, pool_user, is_editable)
    render(:partial => "region_bracket", :locals => {:region => region, :pool_user => pool_user, :is_editable => is_editable})
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
  
  def game_partial(game, bracket_side, top_or_bottom = nil, ancestors_to_include = 0)
    render :partial => 'printable_game', :locals => {:game => game,
                                                     :top_or_bottom => top_or_bottom,
                                                     :ancestors_to_include => ancestors_to_include,
                                                     :bracket_side => bracket_side}
  end
  
  def game_cell(game, pool_user, seed_on_left_or_right)
    bid_cells = game.participating_bids(pool_user).map { |bid| bid_cell(bid, seed_on_left_or_right) }
    bids_table_styles = "width: 100%; " <<
                        "white-space: nowrap; " <<
                        # "border-#{:right == seed_on_left_or_right ? :left : :right}: 1 solid black;" <<
                        "font-size: 10pt;"
    bids_table = content_tag(:table,
                             bid_cells,
                             :style => bids_table_styles)
    content_tag(:td, bids_table, :rowspan => 2 ** (game.round.number - 1), :align => seed_on_left_or_right)
  end
  
  def bid_cell(bid, seed_on_left_or_right)
    seed = content_tag :td, bid.seed, :width => 5, :align => seed_on_left_or_right
    team = content_tag :td, bid.team.name, :align => seed_on_left_or_right
    cell = [seed, team]
    cell.reverse! if :right == seed_on_left_or_right
    content_tag :tr, cell
  end
  
  def region_bracket(region)
    first_game = region.championship_game
    direction = (first_game.parent.top == first_game) ? :left : :right
    content_tag :div, :style => "width: 12cm; float: #{direction};" do
      region.name
      content_tag(:table,
                  game_partial(first_game, direction),
                  :style => "border-collapse: collapse; width: 100%; table-layout: fixed;",
                  :cellpadding => 15)
    end
  end
  
end
