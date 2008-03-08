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
  
end
