require "shart/version"
require 'fog'

module Shart
  # The Target is where the content will be published.
  class Target
    def initialize(directory_name, opts={})
      @directory_name = directory_name
      @storage = Fog::Storage.new(opts)
    end

    def files
      directory.files
    end

    def directory
      @directory ||= @storage.directories.get(@directory_name)
    end

    def sync(source)
      Sync.new(source, self).sync
    end
  end

  # The Source represents where the content is coming from.
  class Source
    def initialize(path)
      @root = Pathname.new(path)
    end

    def files(&block)
      Dir.glob(@root + '**/*').reject{ |p| File.directory?(p) }.inject Hash.new do |hash, source_path|
        hash[source_path] = Pathname.new(source_path).relative_path_from(@root).to_s # Give us the 'key' path that we'll publish to in the target.
        hash
      end
    end

    def sync(target)
      Sync.new(self, target).sync
    end
  end

  # Sync deals with the specifics of getting each file from the source to the target.
  class Sync
    def initialize(source, target)
      @source, @target = source, target
    end

    def sync
      @source.files.each do |path, key|
        @target.files.create({
          :key => key,
          :body => File.open(path),
          :public => true,
          :cache_control => 0
        })
      end
    end
  end
end