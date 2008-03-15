class PoolController < ApplicationController
  
  before_filter :require_authentication, :only => :make_pic
  
  def index
    flash.keep
    redirect_to(:action => "standings")
  end
  
  def brackets
    if request.get?
      get_bracket_info
      @region_order = params[:region_order] ? params[:region_order].to_i : 1
      @region = Region.find(:first, :conditions => ["#{Region.table_name}.season_id = ? AND order_num = ?", *[@season.id, @region_order]])
    else
      if params[:go]
        redirect_to(:action => "brackets", :season_id => params[:season_id], :id => params[:user][:id], :region_order => params[:region_order], :bracket_num => params[:bracket_num])
      else
        # change seasons.
        redirect_to(:action => "brackets", :season_id => params[:season_id], :id => nil)
      end
    end
  end
  
  def make_pic
    if request.xhr?
      bid = Bid.find(params[:bid_id])
      game = Game.find(params[:game_id])
      pool_user = PoolUser.find(params[:pool_user_id], :include => :pics)
      is_first_round_bid = params[:is_first_round_bid]
      bracket_is_complete_before_pic = pool_user.bracket_complete?
      
      # winner.
      if is_first_round_bid
        other_affected_pics = game.declare_winner(bid, pool_user)
        pic = pool_user.pics.for_game game
      else
        other_affected_pics = game.parent.declare_winner(bid, pool_user)
        pic = pool_user.pics.for_game(game.parent)
      end
      
      # have to load pool_user again to update the pics.
      pool_user.reload(:include => :pics)
      
      # need to update bracket completion?
      bracket_is_complete_after_pic = pool_user.bracket_complete?
      update_bracket_completion_to = bracket_is_complete_after_pic if bracket_is_complete_after_pic != bracket_is_complete_before_pic
      
      # render.
      render(:partial => "pic", :locals => {:pic => pic,
                                            :is_editable => is_latest_season?(game.season) && !game.season.tournament_has_started? || logged_in_user.is_admin?,
                                            :pool_user => pool_user,
                                            :other_affected_pics => other_affected_pics,
                                            :update_bracket_completion_to => update_bracket_completion_to})
    end
  end
  
  def bracket_completion
    if request.xhr?
      is_complete = true if "true" == params[:is_complete]
      render(:partial => "bracket_completion", :locals => {:is_complete => is_complete})
    end
  end
  
  def standings
    if request.get?
      @season = Season.find_by_id(params[:season_id])
      @season = latest_season unless @season
      @pool_users = PoolUser.find(:all,
                                  :conditions => ["#{PoolUser.table_name}.season_id = ?", @season.id],
                                  :include => [{:pics => [:bid, {:game => :round}]}, :user])
      @scoring_system = ScoringSystems::SYSTEMS[params[:scoring_system_id].to_i]
      @master_pool_user = @pool_users.detect{|pool_users| User.master_id == pool_users.user_id}
      @pool_users.delete(@master_pool_user)
      @master_pool_user.calculate_points(@master_pool_user.pics, @scoring_system)
      @pool_users.each {|pool_user| pool_user.calculate_points(@master_pool_user.pics, @scoring_system)}
      @pool_users.sort!(&PoolUser.standings_sort_proc)
    else
    # post
      redirect_to :action => "standings", :season_id => params[:season_id], :scoring_system_id => params[:scoring_system_id]
    end
  end
  
  def game_pics
    #@game_id = Game.find(:first, :conditions => ["#{Game.table_name}.id = ?", params[:id]], :include => [:region, {:pics => [{:pool_user => [:pics, :user]}, {:bid => :team}]}])
    @game = Game.find_by_id(params[:id])
    if @game
      if Time.now < @game.season.tournament_starts_at
        @game = nil
        flash.now[:failure] = "you cannot see other players' pics before the tournament."
      else
        @pool_users = PoolUser.find(:all, :conditions => ["#{PoolUser.table_name}.season_id = ?", *[@game.season_id]], :include => [{:pics => [{:bid => :team}, :game]}, :user])
        @master_pool_user = @pool_users.detect { |pu| pu.user_id == User.master_id }
        @pool_users.delete(@master_pool_user)
        @pool_users.sort! { |a, b| a.user.display_name.downcase <=> b.user.display_name.downcase }
      end
    else
      flash[:failure] = "game #{params[:id]} not found."
    end
  end
  
  def pvp
    if request.get?
      redirect_to(:action => "standings", :scoring_system_id => params[:scoring_system_id])
    else
      @pvp_subject = PoolUser.find(:first, :conditions => ["#{PoolUser.table_name}.id = ?", params[:pvp_subject]], :include => [{:pics => :game}, :user])
      if @pvp_subject.nil?
        flash[:failure] = "select a player in the left column to compare."
        redirect_to(:action => "standings", :scoring_system_id => params[:scoring_system_id])
      else
        other_ids = params[:other_pool_user_ids].reject { |id, checked| "1" != checked || id.to_i == @pvp_subject.id }
        @other_pool_users = PoolUser.find(:all, :conditions => ["#{PoolUser.table_name}.id in (?)", other_ids.map { |id, checked| id.to_i }], :include => [{:pics => :game}, :user])
        master_pics = PoolUser.master(@pvp_subject.season).pics
        @scoring_system = ScoringSystems::SYSTEMS[params[:scoring_system_id].to_i]
        @pvp_subject.calculate_points(master_pics, @scoring_system)
        @other_pool_users.each { |pu| pu.calculate_points(master_pics, @scoring_system) }
      end
    end
  end
  
  def printable_bracket
    # render_layout_only 'under construction' and return
    get_bracket_info
    render :layout => false, :footnotes => false
  end
  
  protected
  
  def controller_name_for_page_title
    'march madness'
  end
  
  private
  
  def is_latest_season?(season)
    season == latest_season
  end
  
  helper_method :is_latest_season?
  
  def get_bracket_info
    @season = Season.find_by_id(params[:season_id]) || Season.latest
    @user = User.find_by_id(params[:id])
    @pool_users = @user.pool_users.for_season(@season)
    render_layout_only 'bracket not found' and return if @pool_users.empty?
    # allowed to view if user is self or admin.
    # if tournament hasn't started and requested user is neither self nor admin.
    if is_latest_season?(@season) && !@season.tournament_has_started? && !is_self_or_logged_in_as_admin?(@user)
      msg = "#{@season.year} brackets are private until the tournament starts."
      msg += "<br/>login to make pics." unless logged_in_user
      render_layout_only msg and return
    end
    @pool_user = @user.pool_users.for_season_and_bracket_num(@season, params[:bracket_num])
  end
  
end
