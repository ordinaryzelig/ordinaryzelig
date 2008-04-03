namespace :db do
  
  desc 'db:drop, db:create, db:migrate, db:fixtures:load'
  task :reload => [:environment, :drop, :create, :migrate] do
    sh 'rake db:fixtures:load'
  end
  
end
