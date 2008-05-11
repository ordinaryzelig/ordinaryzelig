module LGS
  
  module MigrationHelpers
    
    module ActiveRecord::ConnectionAdapters::SchemaStatements
      
      def doesnt_support_fkeys
        "sqlite" == ActiveRecord::Base.connection.adapter_name.downcase()
      end
      
      def fkey_name(table, column)
        "#{table}_#{column}_fkey"
      end
      private :fkey_name
      
      # add a foreign key constraint.
      # if only table_name and column_name are passed, it will assume rails conventions.
      # i.e. add_fkey(:blogs, :user_id) will create a foreign key in the blogs table 
      # for the user_id column referencing the id column in the users table.
      # the constraint will be named table_name_column_name_fkey.
      # options:
      #   :reference_table - defaults to rails convention naming.  e.g. user_id -> users.
      #   :reference_column - defaults to id.
      #   :name - user-specified name for fkey.
      def add_fkey(table_name, column_name, options = {})
        return if doesnt_support_fkeys
        options[:name] ||= fkey_name table_name, column_name
        options[:reference_table] ||= Inflector.pluralize(column_name.to_s.gsub /_id$/, '')
        options[:reference_column] ||= 'id'
        execute "alter table #{table_name} add constraint #{options[:name]} foreign key (#{column_name}) references #{options[:reference_table]} (#{options[:reference_column]})"
      end
      
      # drops the foreign key constraint
      # based on the naming convention mentioned in add_fkey unless name given in options.
      def drop_fkey(table_name, options = {})
        return if doesnt_support_fkeys
        opts = options.dup
        opts[:name] ||= fkey_name(table_name, opts[:column])
        # check adapter in use.
        adapter_name = ActiveRecord::Base.connection.adapter_name.downcase
        drop_what = case adapter_name
        when 'mysql'
          'foreign key'
        when 'postgresql'
          'constraint'
        else
          raise "drop_fkey only works for mysql and postgres right now.  you're using #{adapter_name}."
        end
        execute "alter table #{table_name} drop #{drop_what} #{opts[:name]}"
      end
      
      # create a view called table_name based on "select * from source_db_name".
      # right now, sql security is set to invoker.
      def create_view(view_name, table_name)
        execute "create sql security invoker view #{view_name} as select * from #{table_name}"
      end
      
      # drop a view.
      def drop_view(view_name)
        execute "drop view #{view_name}"
      end
      
    end
    
  end
    
end
