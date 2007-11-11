class CatchAllController < ApplicationController
  
  def show
    @page = Page.find_by_path(params[:path])
    @page_title = @page ? @page.title : 'page not found'
  end
  
end
