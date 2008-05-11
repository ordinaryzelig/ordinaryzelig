unless 'production' == ENV['RAILS_ENV']
  require 'has_finder'
  require 'will_paginate'
end
