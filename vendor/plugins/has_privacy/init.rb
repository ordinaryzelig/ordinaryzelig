Dependencies.load_once_paths.delete(File.dirname(__FILE__) + '/lib')

require 'has_privacy'
ActiveRecord::Base.send 'include', OrdinaryZelig::HasPrivacy
