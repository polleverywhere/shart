require "shart/version"
require 'fog'
require 'pathname'

module Shart
  # The Target is where the content will be published.
  class Target
    attr_reader :directory_name

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
    attr_reader :root

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

  # Process info a Shartfile
  class DSL
    def target(directory_name, opts={})
      @target = Target.new(directory_name, opts)
    end

    def source(path)
      @source = Source.new(path)
    end

    def sync
      Sync.new(@source, @target)
    end

    def self.shartfile(filename)
      sync = new.tap { |dsl| dsl.instance_eval(File.read(filename), filename) }.sync
      puts "Sharting from #{sync.source.root.to_s.inspect} to #{sync.target.directory_name.inspect}"
      sync.run do |path, key, file|
        puts " #{key.inspect}"
      end
    end
  end

  # Sync deals with the specifics of getting each file from the source to the target.
  class Sync
    attr_reader :source, :target

    def initialize(source, target)
      @source, @target = source, target
    end

    def run(&block)
      @source.files.each do |path, key|
        block.call path, key, @target.files.create({
          :key => key,
          :body => File.open(path),
          :public => true,
          :cache_control => 0 # Disable cache on S3 so that future sharts are visible if folks web browsers.
        })
      end
    end
  end
end