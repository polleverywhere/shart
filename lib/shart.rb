# Encoding: UTF-8

require "shart/version"
require 'fog'
require 'pathname'

module Shart
  # The Target is where the content will be published.
  class Target
    attr_reader :directory_name, :storage

    def initialize(directory_name, opts={})
      @directory_name = directory_name
      @storage = Fog::Storage.new(opts)
    end

    def files
      directory.files
    end

    def directory
      @directory ||= storage.directories.get(@directory_name)
    end

    def sync(source)
      Sync.new(source, self).run
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
        key = Pathname.new(source_path).relative_path_from(@root).to_s 
        hash[key] = File.new(source_path) # Give us the 'key' path that we'll publish to in the target.
        hash
      end
    end

    def sync(target)
      Sync.new(self, target).run
    end
  end

  # Register processing rules for objects with an Engine.
  class Engine
    # Add a rule to the engine. Based on Dir.glob patterns from the objects on
    # the file system.
    def rule(pattern, &block)
      rules << [pattern, block]
    end

    # Process the stinkin rules mang.
    def process(object)
      rules.each { |pattern, rule| object.instance_eval(&rule) if self.class.match(pattern, object.key) }
    end

  private
    def self.match(pattern, key)
      case pattern
      when String
        File.fnmatch(pattern, key)
      when Regexp
        key =~ pattern
      end
    end

    def rules
      @rules ||= []
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
      Sync.new(@source, @target, @engine)
    end

    def path(*paths, &block)
      paths.each { |path| engine.rule path, &block }
    end

    def self.shartfile(filename)
      sync = new.tap { |dsl| dsl.instance_eval(File.read(filename), filename) }.sync
      puts "Sharting from #{sync.source.root.to_s.inspect} to #{sync.target.directory_name.inspect}"
      sync.upload do |file, object|
        puts "#{file.path} → #{object.public_url}"
      end
      sync.clean do |object|
        puts "✗ #{object.public_url}"
      end
    end

  private
    def engine
      @engine ||= Engine.new
    end
  end

  # Sync deals with the specifics of getting each file from the source to the target.
  class Sync
    attr_reader :source, :target, :engine

    def initialize(source, target, engine = Engine.new)
      @source, @target, @engine = source, target, engine
    end

    # Upload files from target to the source.
    def upload(&block)
      @source.files.each do |key, file|
        object = @target.files.new({
          :key => key,
          :body => file,
          :public => true,
          :cache_control => 'max-age=0' # Disable cache by default on S3 so that future sharts are visible if folks web browsers.
        })
        engine.process object
        block.call file, object
        object.save
      end
    end

    # Removes files from target that don't exist on the source.
    def clean(&block)
      @target.files.each do |object|
        unless @source.files.include? object.key
          block.call(object)
          object.destroy
        end
      end
    end
  end
end