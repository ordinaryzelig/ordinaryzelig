desc 'Create YAML test fixtures from data in an existing database. Defaults to development database. Set RAILS_ENV to override.'

task :extract_fixtures => :environment do
  sql = "SELECT * FROM %s order by coalesce(parent_id, id)"
  skip_tables = ["schema_info", 'sessions']
  ActiveRecord::Base.establish_connection
  # (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
  [:comments].each do |table_name|
    i = "000"
    File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w') do |file|
      data = ActiveRecord::Base.connection.select_all(sql % table_name)
      data.each { |record| file.write ["#{table_name}_#{record['id']}", record.to_yaml] }
      # file.write data.inject({}) { |hash, record|
      #   hash["#{table_name}_#{i.succ!}"] = record
      #   hash
      # }.to_yaml
    end
  end
end
