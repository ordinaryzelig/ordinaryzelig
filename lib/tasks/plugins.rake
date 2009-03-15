namespace 'plugins' do
  
  PLUGINS = 
  {
    'acts_as_list' => 'git://github.com/rails/acts_as_list.git',
    'acts_as_tree' => 'git://github.com/rails/acts_as_tree.git',
    'can-be-marked-as-read' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/can-be-marked-as-read.git',
    'can-be-summarized' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/can-be-summarized.git',
    'can-be-syndicated-by' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/can-be-syndicated-by.git',
    'console_script_runner' => 'git://github.com/ordinaryzelig/console-script-runner.git',
    'has-nested-comments' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/has-nested-comments.git',
    'has-privacy' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/has-privacy.git',
    'has-recency' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/has-recency.git',
    # for some reason, rails doesn't like migration_helpers with a dash instead of underscore.
    'migration_helpers' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/migration-helpers.git',
    'model_class' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/model_class.git',
    'nil-if-blank' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/nil-if-blank.git',
    'polymorphic-entity' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/polymorphic-entity.git',
    'previewable' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/previewable.git',
    'test-helper-helpers' => 'git@ordinaryzelig.unfuddle.com:ordinaryzelig/test-helper-helpers.git',
  }
  
  # plugins to install not in production environment.
  PLUGINS.merge!(
    'footnotes' => 'git://github.com/drnic/rails-footnotes.git'
  ) if RAILS_ENV != 'production'
  
  desc 'Checkout fresh plugins'
  task :install => [:clean, :checkout] do
  end
  
  desc 'svn checkout each listed plugin.  tag/trunk depends on rails environment.'
  task :checkout do
    path = File.join('vendor','plugins')
    FileUtils.mkdir_p(path)
    each_plugin do |plugin, path|
      puts plugin
      sh %{git clone #{path} #{plugin}}
    end
    # footnotes version for rails 2.1.x.
    if PLUGINS['footnotes']
      Dir.chdir 'vendor/plugins/footnotes' do
        sh 'git checkout v3.2.2'
      end
    end
  end
  
  desc 'clear out the plugins directory.'
  task :clean do
    FileUtils.mkdir_p(File.join('vendor','plugins'))
    each_plugin do |plugin, path|
      FileUtils.remove_entry_secure(plugin) if File.exists?(plugin)
    end
  end
  
  desc 'check the svn status of each plugin.'
  task :status do
    each_plugin do |plugin, path|
      Dir.chdir(plugin) do
        puts plugin
        sh "git status"
      end
    end
  end
  
  desc 'svn update each listed plugin.'
  task :update do
    each_plugin do |plugin, path|
      puts "#{plugin}:"
      sh "svn up #{plugin}"
    end
  end
  
  # temporarily change directory to plugins and iterate through defined plugins.
  # don't stop on exception unless told to do so.
  def each_plugin(stop_on_exception = false)
    Dir.chdir('vendor/plugins') do
      PLUGINS.each do |plugin, path|
        begin
          yield plugin, path
        rescue Exception => ex
          puts ex
          raise if stop_on_exception
        end
      end
    end
  end
  
  def git?(path)
    path =~ /\.git$/
  end
  
end
