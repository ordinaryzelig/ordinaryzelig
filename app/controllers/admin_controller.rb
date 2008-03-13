class AdminController < ApplicationController
  
  before_filter :require_authentication
  
  def index
    flash.keep
    redirect_to(:action => "users")
  end
  
  def edit_season
    @season = Season.find_by_id(params[:id]) || Season.new
    if request.post?
      @season.attributes = params[:season]
      redirect_to :action => 'select_team_bids', :id => @season.id if @season.save
    end
  end
  
  def select_team_bids
    @season = Season.find(params[:id])
    if request.post?
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
      params[:region_names].each do |region_id, name|
        Region.find(region_id).update_attribute(:name, name)
      end
      flash[:success] = "bids and regions saved."
      redirect_to(:controller => "pool", :action => "brackets", :season_id => params[:season_id], :id => User.master_id)
    end
  end
  
  def users
    @users = User.find(:all).reject{|user| 1 == user.is_admin}.sort{|x, y| x.last_name.downcase <=> y.last_name.downcase}
  end
  
  # params
  #   season_id
  def participation
    @season = Season.find_by_id(params[:season_id])
    @season = Season.latest unless @season
    if request.get?
      @users = User.find(:all, :include => {:pool_users => :pics}, :order => User.default_order_by_string)
      @users.reject! { |user| user.id == User.master_id || user.is_admin? }
    else
      redirect_to(:action => "participation", :season_id => params[:season_id])
    end
  end
  
  def enter_pool
    if request.post?
      season = Season.find(params[:season_id])
      pool_user = PoolUser.create!(:season_id => params[:season_id], :user_id => params[:id])
      flash[:success] = "#{pool_user.user.last_first_display} entered pool"
      redirect_to(:action => "participation", :season_id => season.id)
    end
  end
  
  # params
  #   season_id (optional)
  def buy_ins
    if request.get?
      @season = Season.find_by_id(params[:season_id]) || latest_season
      @users = User.find(:all, :conditions => ["#{PoolUser.table_name}.season_id = ?", @season.id], :include => :pool_users, :order => User.default_order_by_string)
      @users.delete_if{|user| User.master == user }
    else
    # post.
      redirect_to(:action => "buy_ins", :season_id => params[:season_id])
    end
  end
  
  def pay
    if request.post?
      User.find(params[:id]).accounts.for_season(Season.find(params[:season_id])).pay
      redirect_to(:action => "buy_ins")
    end
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
