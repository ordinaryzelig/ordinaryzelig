module LGS
  
  module MigrationHelpers
    
    def self.included(base)
      base.extend LGS::MigrationHelpers::ClassMethods
    end
    
    module ClassMethods
      
      def fkey(table_name, field_name, other_table = Inflector.pluralize(field_name.to_s.gsub('_id', '')))
        execute "alter table #{table_name} add constraint #{table_name}_#{field_name}_fkey foreign key (#{field_name}) references #{other_table} (id);"
      end
      
    end
    
  end
  
end