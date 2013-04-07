# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shart/version'

Gem::Specification.new do |gem|
  gem.name          = "shart"
  gem.version       = Shart::VERSION
  gem.authors       = ["Brad Gessler"]
  gem.email         = ["brad@bradgessler.com"]
  gem.description   = %q{Deploys static websites like Middleman to cloud storage providers like S3.}
  gem.summary       = %q{Shart makes it easy to deploy static websites to cloud storage providers. Works great with Middleman, Jekyll, or Dreamweaver websites.}
  gem.homepage      = "http://github.com/polleverywhere/shart"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "fog"
end
