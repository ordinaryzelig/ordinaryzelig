# two-sided migrations (TSMs) will automate rollbacks (self.down) of your migration.
# TSMs should define up and down where down has the exact opposite effect of up.




module TwoSidedMigration
  
  # abstract super class that defines up and down and raises exception if they are not defined in subclass.
  class Base
    def up
      raise "you did not define \"up\" in #{self.class}."
    end
    def down
      raise "you did not define \"down\" in #{self.class}."
    end
    private
    # attempt to call it from ActiveRecord::Migration.
    def method_missing(method_name, *args, &block)
      ActiveRecord::Migration.send method_name, *args, &block
    end
    protected
    def compact_args(*options)
      # puts options.first.respond_to? :empty?
      options.map { |opt| (opt.respond_to?(:empty?) && opt.empty?) ? nil : opt }.compact
    end
  end # Base
  
  # make 2 subclasses of the abstract superclass.
  # one that will execute the positive_action_name for up and negative for down.
  # the second will do the opposite.
  # for example, FKey abstract class will have 2 subclasses.  AddFKey and DropFKey.
  # AddFKey.up will add the foreign key and down will drop it.
  # DropFKey.up will drop the foreign key and down will add it.
  def self.subclasses_for(superclass, positive_action_name, negative_action_name)
    define_subclass superclass, positive_action_name, negative_action_name
    define_subclass superclass, negative_action_name, positive_action_name
  end
  
  private
  def self.define_subclass(superclass, positive_action_name, negative_action_name)
    class_name = class_name_for superclass, positive_action_name
    module_eval <<-END
      class #{class_name} < #{superclass}
        def up
          #{positive_action_name}
        end
        def down
          #{negative_action_name}
        end
      end
    END
  end
  
  def self.class_name_for(superclass, action_name)
    "#{action_name.to_s.camelize}#{superclass.to_s.demodulize}"
  end
  
  # execute a group of TSMs.
  class Group < Base
    attr_accessor :tsms
    def initialize(*tsms)
      @tsms = tsms
      @successful_tsms = []
    end
    def up
      migrate :up
    end
    def down
      migrate :down
    end
    private
    def migrate(direction)
      (:up == direction ? tsms : tsms.reverse).each do |tsm|
        tsm.send direction
        @successful_tsms << tsm
      end
    rescue => ex
      STDERR.puts ["error on TSM #{@successful_tsms.size}",
            "rolling back."].join("\n")
      @successful_tsms.reverse.each { |tsm| tsm.send opposite(direction) }
      raise ex
    end
    def opposite(direction)
      :up == direction ? :down : :up
    end
  end
  
  # =================================================
  # built in TwoSidedMigrations.
  
  class ChangeColumn < Base
    attr_reader :table_name, :column_name, :new_type, :new_options, :old_type, :old_options
    def initialize(table_name, column_name, new_type, old_type, new_options = {}, old_options = {})
      @table_name, @column_name, @new_type, @old_type, @new_options, @old_options = table_name, column_name, new_type, old_type, new_options, old_options
    end
    def up
      change_column *compact_args(table_name, column_name, new_type, new_options)
    end
    def down
      change_column *compact_args(table_name, column_name, old_type, old_options)
    end
  end
  
  class Column < Base
    attr_reader :table_name, :column_name, :type, :options
    def initialize(table_name, column_name, type, options = {})
      @table_name, @column_name, @type, @options = table_name, column_name, type, options
    end
    def add
      add_column *compact_args(table_name, column_name, type, options)
    end
    def remove
      remove_column table_name, column_name
    end
  end
  subclasses_for Column, :add, :remove
  
  class Execute < Base
    attr_reader :up_sql, :down_sql
    def initialize(up_sql, down_sql)
      @up_sql, @down_sql = up_sql, down_sql
    end
    def up
      execute up_sql
    end
    def down
      execute down_sql
    end
  end
  
  class FKey < Base
    attr_reader :table_name, :column_name, :options
    def initialize(table_name, column_name, options = {})
      @table_name, @column_name, @options = table_name, column_name, options
    end
    protected
    def add
      add_fkey *compact_args(table_name, column_name, options.dup)
    end
    def drop
      opts = options.dup
      opts[:column] = column_name if column_name
      drop_fkey *compact_args(table_name, opts)
    end
  end
  subclasses_for FKey, :add, :drop
  
  class Index < Base
    attr_reader :table_name, :column_name, :options
    def initialize(table_name, column_name, options = {})
      @table_name, @column_name, @options = table_name, column_name, options
    end
    protected
    def add
      add_index *compact_args(table_name, column_name, options.dup)
    end
    def remove
      if options[:name]
        opts = {:name => options[:name].dup}
      else
        opts = options.dup
        opts[:column] = column_name
      end
      remove_index table_name, opts
    end
  end
  subclasses_for Index, :add, :remove
  
  class RenameColumn < Base
    attr_reader :table_name, :old_column_name, :new_column_name
    def initialize(table_name, old_column_name, new_column_name)
      @table_name, @old_column_name, @new_column_name = table_name, old_column_name, new_column_name
    end
    def up
      rename_column table_name, old_column_name, new_column_name
    end
    def down
      rename_column table_name, new_column_name, old_column_name
    end
  end
  
  class RenameTable < Base
    attr_reader :old_table_name, :new_table_name
    def initialize(old_table_name, new_table_name)
      @old_table_name, @new_table_name = old_table_name, new_table_name
    end
    def up
      rename_table old_table_name, new_table_name
    end
    def down
      rename_table new_table_name, old_table_name
    end
  end
  
  class Table < Base
    attr_reader :table_name, :options, :definition
    def initialize(table_name, options = {}, &definition)
      @table_name, @options, @definition = table_name, options, definition
    end
    protected
    def create
      create_table *compact_args(table_name, options), &definition
    end
    def drop
      drop_table table_name
    end
  end
  subclasses_for Table, :create, :drop
  
  # ==================================================================================
  # use_two_sided_migration class method.
  # will define self.up and self.down.
  
  def self.included(base)
    base.module_eval do
      def self.use_two_sided_migration
        class << self
          define_method 'up' do
            yield.up
          end
          define_method 'down' do
            yield.down
          end
        end
      end
    end
  end
  
end # TwoSidedMigration
