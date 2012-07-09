# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rack-emstream/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["John Bintz"]
  gem.email         = ["john@coswellproductions.com"]
  gem.description   = %q{Super-simple Rack streaming with Thin}
  gem.summary       = %q{Super-simple Rack streaming with Thin}
  gem.homepage      = "http://github.com/johnbintz/rack-emstream/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rack-emstream"
  gem.require_paths = ["lib"]
  gem.version       = Rack::EMStream::VERSION

  gem.add_dependency 'eventmachine'
end
