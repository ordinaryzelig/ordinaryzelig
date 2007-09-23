module LGS
  
  module MigrationHelpers
    
    def self.included(base)
      base.extend LGS::MigrationHelpers::ClassMethods
    end
    
    module ClassMethods
      
      def fkey(table_name, field_name, other_table = Inflector.pluralize(field_name.to_s.gsub('_id', '')), other_field_name = 'id')
        execute "alter table #{table_name} add constraint #{table_name}_#{field_name}_fkey foreign key (#{field_name}) references #{other_table} (#{other_field_name});"
      end
      
      def remove_fkey(table_name, field_name)
        execute "alter table #{table_name} drop constraint #{table_name}_#{field_name}_fkey;"
      end
      
    end
    
  end
  
end
