ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'
  
  # welcome page.
  map.connect '', :controller => "home", :action => "welcome"
  
  # login.
  map.connect 'login', :controller => "login", :action => "login"
  map.connect 'logout', :controller => "login", :action => "logout"
  
  # pool -> march_madness.
  map.connect 'march_madness/:action/:id', :controller => 'pool'
  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  
  # catch all.
  map.catch_all '*path', :controller => 'catch_all', :action => 'show'
  # http://media.railscasts.com/ipod_videos/034_named_routes.m4v
  
end
