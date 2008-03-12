namespace :db do
  
  desc 'migrate to 0, migrate to current'
  task :reset => :environment do
    sh 'rake db:migrate VERSION=0'
    sh 'rake db:migrate'
  end
  
  desc 'db:reload and db:fixtures:load'
  task :reload => [:reset] do
    sh 'rake db:fixtures:load'
  end
  
end
