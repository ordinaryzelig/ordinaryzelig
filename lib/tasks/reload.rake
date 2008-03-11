namespace :db do
  
  desc 'load app and lgs_user fixtures'
  task :load_all_fixtures do
    sh 'rake db:fixtures:plugins:load PLUGIN=lgs_user'
    sh 'rake db:fixtures:load'
  end
  
  desc 'migrate to 0, migrate to current'
  task :reset => :environment do
    sh 'rake db:migrate VERSION=0'
    sh 'rake db:migrate'
  end
  
  desc 'db:reload and db:load_all_fixtures'
  task :reload => [:reset, :load_all_fixtures]
  
end
