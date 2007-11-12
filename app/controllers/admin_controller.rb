class AdminController < ApplicationController
  
  before_filter :require_authentication
  
  def index
    flash.keep
    redirect_to(:action => "users")
  end
  
  def create_new_season
    if request.post?
      @season = Season::new_season
      redirect_to(:action => :edit_season, :id => @season.id)
    end
  end
  
  # params
  #   id (season)
  def edit_season
    if request.get?
      @season = Season.find(:first, :conditions => ["#{Season.table_name}.id = ?", params[:id]], :include => :regions) || current_season
    else
      if params[:save]
        @season = Season.find(params[:season][:id])
        @season.update_attributes(params[:season])
        @season.tournament_year = @season.tournament_starts_at.year
        @season.save
        # assign region names.
        params.each do |key, val|
          if "region_" == key[0..6]
            region = Region.find(key.gsub("region_", ""))
            region.name = val
            region.save
          end
        end
      else
        redirect_to(:action => "edit_season", :id => params[:season_id])
      end
    end
  end
  
  # select bids for a season.
  # get:
  #   get all regions in given season.
  #   params:
  #     season_id
  # post:
  #   find bid, assign team_id, and save.
  #   params:
  #     "bid_#{bid.id}"[:team_id]
  #     season_id
  def select_team_bids
    if request.get?
      @season = Season.find_by_id(params[:season_id]) || current_season
      @regions = Region.find(:all,
                              :conditions => ["order_num != 0 AND #{Region.table_name}.season_id = ?", @season.id],
                              :include => {:games => :bids})
    else
      if params[:save]
        params[:bids].each do |bid_array|
          Bid.find(bid_array[0]).update_attributes(:team_id => bid_array[1])
        end
        params.each do |key, val|
          if "bid_" == key[0..3]
            bid = Bid.find(key.gsub("bid_", ""))
            bid.team_id = val[:team_id]
            bid.save
          end
        end
        redirect_to(:controller => "pool", :action => "brackets", :season_id => params[:season_id], :id => User::master_id)
      else
        redirect_to(:action => "select_team_bids", :season_id => params[:season_id])
      end
    end
  end
  
  def seasons
    @seasons = Season.find(:all, :order => "tournament_year")
  end
  
  # params
  #   id (season)
  def mark_season_current
    if request.post?
      # get current season and mark as not current.
      @seasons = Season.find(:all, :order => "tournament_year")
      previous_current_season = @seasons.detect{|season| 1 == season.is_current}
      if previous_current_season
        previous_current_season.is_current = nil
        previous_current_season.save
      end
      # mark params season as current.
      new_current_season = @seasons.detect{|season| params[:id].to_i == season.id}
      new_current_season.is_current = 1
      new_current_season.save
      redirect_to(:action => "seasons")
    end
  end
  
  def users
    @users = User.find(:all).reject{|user| 1 == user.is_admin}.sort{|x, y| x.last_name.downcase <=> y.last_name.downcase}
  end
  
  # params
  #   id
  def toggle_authorization
    if request.post?
      user = User.find_by_id(params[:id])
      user.toggle_authorization
      user.save
      render(:partial => "user_authorization", :locals => {:user => user})
    end
  end
  
  # params
  #   season_id
  def participation
    @season = Season.find_by_id(params[:season_id])
    @season = Season::current unless @season
    if request.get?
      @users = User.find(:all, :include => {:pool_users => :pics}, :order => User.default_order_by_string)
      @users.reject! { |user| user.id == User::master_id || user.is_admin? }
    else
      redirect_to(:action => "participation", :season_id => params[:season_id])
    end
  end
  
  # params
  #   id (user)
  #   season_id
  def enter_pool
    if request.post?
      season = Season.find(params[:season_id])
      user = User.find_by_id(params[:id])
      if user
        if user.season_pool_users(season.id).size < season.max_num_brackets
          pool_user = user.enter_pool(season.id, next_bracket_num(user.pool_users.reject{|pu| pu.season_id != season.id}))
          flash[:success] = "user #{user.id} entered in pool."
        else
          flash[:failure] = "#{last_first_display(user)} has the max number of brackets (#{season.max_num_brackets}) for that season."
        end
      else
        flash[:failure] = "user #{params[:user]} not found."
      end
      redirect_to(:action => "participation", :season_id => season.id)
    end
  end
  
  # params
  #   season_id (optional)
  def buy_ins
    if request.get?
      @season = Season.find_by_id(params[:season_id]) || current_season
      @users = User.find(:all, :conditions => ["#{PoolUser.table_name}.season_id = ?", @season.id], :include => :pool_users, :order => User.default_order_by_string)
      @users.delete_if{|user| User::master == user }
    else
    # post.
      redirect_to(:action => "buy_ins", :season_id => params[:season_id])
    end
  end
  
  # params
  #   user
  #   season
  def pay
    if request.get?
      get_for_post
      redirect_to(:action => "buy_ins")
    else
    # post.
      user = User.find(:first, :conditions => ["#{User.table_name}.id = ? AND #{Account.table_name}.season_id = ?", *[params[:user], params[:season]]], :include => {:accounts => :season})
      user.account(params[:season].to_i).pay
    end
    redirect_to(:action => "buy_ins")
  end
  
  def set_password
    @user = User.find_by_id(params[:id])
    if request.post?
      if @user.set_password!(params[:new_password])
        flash[:success] = "password set"
        redirect_to :action => 'users'
      end
    end
  end
  
  def new_user
    @user = params[:user] ? User.new(params[:user]) : User.new
    flash[:success] = "user #{@user.id} created." and redirect_to(:controller => "admin", :action => "users") if request.post? && @user.save
  end
  
  def pages
    @pages = Page.find(:all)
  end
  
  def edit_page
    @page = Page.find_by_id(params[:id]) || Page.new
    if request.post?
      @page.attributes = params[:page]
      flash[:success] = "page saved" and redirect_to(catch_all_url(@page.path)) if @page.save!
    end
  end
  
  preview_action_for :pages, :use_simp_san => false
  
  private
  
  # return the lowest number that isn't taken.
  # not fully tested.
  def next_bracket_num(pool_users, min_num = 1)
    next_bracket_num = min_num
    existing = pool_users.detect{|pool_user| next_bracket_num == pool_user.bracket_num}
    if existing
      next_bracket_num(pool_users, next_bracket_num + 1)
    else
      next_bracket_num
    end
  end
  
  # overwrite.
  def is_admin_action?(action = action_name)
    true
  end
  
end
