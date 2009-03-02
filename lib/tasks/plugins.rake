namespace 'plugins' do
  
  PLUGINS = 
  {
    'acts_as_list' => 'git://github.com/rails/acts_as_list.git',
    'acts_as_tree' => 'git://github.com/rails/acts_as_tree.git',
    'can_be_marked_as_read' => '/Users/ningj/git/can_be_marked_as_read',
    'can_be_summarized' => '/Users/ningj/git/can_be_summarized',
    'can_be_syndicated_by' => '/Users/ningj/git/can_be_syndicated_by',
    'has_nested_comments' => '/Users/ningj/git/has_nested_comments',
    'has_privacy' => '/Users/ningj/git/has_privacy',
    'has_recency' => '/Users/ningj/git/has_recency',
    'migration_helpers' => '/Users/ningj/git/migration_helpers',
    'nil_if_blank' => '/Users/ningj/git/nil_if_blank',
    'polymorphic_entity' => '/Users/ningj/git/polymorphic_entity',
    'previewable' => '/Users/ningj/git/previewable',
    'test_helper_helpers' => '/Users/ningj/git/test_helper_helpers',
    'with_scopes' => '/Users/ningj/git/with_scopes',
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
      sh "git st #{plugin}"
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
