module OrdinaryZelig
  
  module WithScopes
    
    # recursively apply scopes and then find.
    # e.g. Family.find_all_with_scopes {:conditions => 'id % 2 = 1'}, {:conditions => "name like 'lop%'"}
    def find_all_with_scopes(*scopes)
      if scopes.nil? || scopes.empty?
        find :all
      else
        with_scope :find => scopes.shift do
          find_all_with_scopes *scopes
        end
      end
    end
    
    def find_with_scopes(*scopes)
      find_all_with_scopes(*scopes).first
    end
    
    # return scopes.  define scopes if not already.
    def scopes
      self.const_set 'SCOPES', {} unless self.const_defined?('SCOPES')
      self::SCOPES
    end
    
  end
  
end
