class PoolController < ApplicationController
  
  before_filter :require_authentication, :only => :make_pic
  
  def index
    flash.keep
    redirect_to(:action => "standings")
  end
  
  def bracket
    get_bracket_info
  end
  
  def make_pic
    if request.post?
      @bid = Bid.find(params[:bid_id])
      @game = Game.find(params[:game_id])
      @pool_user = PoolUser.find(params[:pool_user_id], :include => :pics)
      raise "#{logged_in_user.first_last} trying to edit #{@pool_user.user.first_last} pics" unless @pool_user.is_editable_by?(logged_in_user)
      bracket_is_complete_before_pic = @pool_user.bracket_complete?
      
      # winner.
      @other_affected_pics = @game.declare_winner(@bid, @pool_user)
      @pic = @pool_user.pics.for_game @game
      
      # have to load pool_user again to update the pics.
      @pool_user.reload(:include => :pics)
      
      # need to update bracket completion?
      bracket_is_complete_after_pic = @pool_user.bracket_complete?
      @update_bracket_completion_to = bracket_is_complete_after_pic if bracket_is_complete_after_pic != bracket_is_complete_before_pic
      
      respond_to do |format|
        format.html { redirect_to :action => 'bracket', :season_id => @game.season_id, :id => @pool_user.user_id, :region_order => (@game.parent ? @game.parent.region.order_num : @game.region.order_num), :bracket_num => @pool_user.bracket_num }
        format.js
      end
    end
  end
  
  def standings
    if request.get?
      get_season_from_params
      rescue_friendly do
        get_scoring_system_from_params
        master_pool_user = @season.pool_users.master.reload(:include => [{:pics => [:bid, {:game => :round}]}, :user])
        master_pool_user.calculate_points(master_pool_user.pics, @scoring_system)
        @pool_users_with_rank = [[master_pool_user, nil]] + @season.pool_users.by_rank(@scoring_system)
        # @show_pvp_selectors = @season.tournament_has_started? && !master_pool_user.bracket_complete?
        @show_pvp_selectors = false
      end
    else
      redirect_to :action => "standings", :season_id => params[:season_id], :scoring_system_id => params[:scoring_system_id]
    end
  end
  
  def game_pics
    rescue_friendly do
      @game = Game.find_by_id params[:id], :include => [:region, {:pics => [{:pool_user => [:pics, :user]}, {:bid => :team}]}]
      raise FriendlyError.new("you cannot see other players' pics before the tournament.") unless @game.season.tournament_has_started?
      @pool_users_with_rank = @game.season.pool_users.by_rank
      @master_pool_user = @game.season.pool_users.master
    end
  end
  
  def pvp
    @pvp_subject = PoolUser.find(:first, :conditions => ["#{PoolUser.table_name}.id = ?", params[:pool_user_id]], :include => [{:pics => :game}, :user])
    if @pvp_subject.nil?
      flash[:failure] = "select a player in the left column to compare."
      redirect_to(:action => "standings", :scoring_system_id => params[:scoring_system_id])
    else
      # other_ids = params[:other_pool_user_ids].reject { |id, checked| "1" != checked || id.to_i == @pvp_subject.id }
      @other_pool_users = PoolUser.find(:all, :conditions => ["#{PoolUser.table_name}.id in (?)", params[:other_pool_user_ids]], :include => [{:pics => :game}, :user])
      @other_pool_users.delete @pvp_subject
      master_pics = PoolUser.master(@pvp_subject.season).pics
      get_scoring_system_from_params
      @pvp_subject.calculate_points(master_pics, @scoring_system)
      @other_pool_users.each { |pu| pu.calculate_points(master_pics, @scoring_system) }
    end
  end
  
  def printable_bracket
    get_bracket_info
    @printable = true
    render :layout => false, :footnotes => false
  end
  
  def select_bracket
    @pool_user = PoolUser.find params[:id]
    redirect_to :action => 'bracket', :season_id => @pool_user.season_id, :id => @pool_user.user_id
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
    get_season_from_params
    get_user_from_params
    rescue_friendly 'bracket not found' do
      # allowed to view if user is self or admin.
      # if tournament hasn't started and requested user is neither self nor admin.
      get_user_from_params
      if !@season.tournament_has_started? && !is_self_or_logged_in_as_admin?(@user) && @user.id != User.master_id
        msg = "#{@season.year} brackets are private until the tournament starts."
        msg += "<br/>login to make pics." unless logged_in_user
        raise FriendlyError.new(msg)
      end
      @pool_users = @user.pool_users.for_season(@season)
      raise FriendlyError.new('user not participating in this season') if @pool_users.empty?
    end
    @pool_user = @user.pool_users.for_season_and_bracket_num(@season, params[:bracket_num])
  end
  
  def get_season_from_params
    rescue_friendly('could not find season') { @season = Season.find_by_id(params[:season_id]) || latest_season }
  end
  
  def get_user_from_params
    rescue_friendly('could not find user') { @user = User.find_by_id(params[:id]) }
  end
  
  def get_scoring_system_from_params
    rescue_friendly 'could not find scoring system' do
      id = params[:scoring_system_id]
      id = id.to_i if id
      @scoring_system = ScoringSystems::SYSTEMS[id]
    end
  end
  
end
