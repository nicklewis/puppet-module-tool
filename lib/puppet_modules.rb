require 'pathname'
require 'fileutils'

module PuppetModules
  
  autoload :Applications,        'puppet_modules/applications'
  autoload :Cache,               'puppet_modules/cache'
  autoload :ContentsDescription, 'puppet_modules/contents_description'
  autoload :Dependency,          'puppet_modules/dependency'
  autoload :Metadata,            'puppet_modules/metadata'
  autoload :Modulefile,          'puppet_modules/modulefile'
  autoload :Repository,          'puppet_modules/repository'
  autoload :Utils,               'puppet_modules/utils'

  def self.root
    @root ||= Pathname.new(__FILE__).parent + '..'
  end

  def self.repository
    @repository ||= Repository.new
  end
  
  def self.repository=(url)
    @repository = Repository.new(url)
  end

  def self.dotdir
    @dotdir ||=
      begin
        path = Pathname.new(ENV['HOME']) + '.puppet-modules'
        path.mkpath
        path
      end
  end

end

