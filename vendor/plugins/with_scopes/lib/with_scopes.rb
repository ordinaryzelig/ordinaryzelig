module LGS
  
  module WithScopes
    
    # recursively apply scopes and then find.
    # e.g.:
    #   Family.with_scopes {:conditions => 'id % 2 = 1'}, {:conditions => "name like 'lop%'"} do
    #     Family.find :all
    #   end
    def with_scopes(*scopes, &block)
      if scopes.nil? || scopes.empty?
        yield
      else
        with_scope :find => scopes.shift do
          with_scopes *scopes, &block
        end
      end
    end
    
    # return scopes.  define scopes if not already.
    def scopes
      self.const_set 'SCOPES', {} unless self.const_defined?('SCOPES')
      self::SCOPES
    end
    
  end
  
end
