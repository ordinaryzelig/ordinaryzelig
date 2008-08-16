namespace :db do
  
  desc 'db:reload and db:fixtures:load'
  task :reload => [:environment, :drop, :create, :migrate] do
    sh 'rake db:fixtures:load'
  end
  
end
