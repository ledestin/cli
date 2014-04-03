# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ninefold/version'

Gem::Specification.new do |spec|
  spec.name          = "ninefold"
  spec.version       = Ninefold::VERSION
  spec.authors       = ["Yehuda Katz", "Nikolay Nemshilov"]
  spec.email         = ["wycats@gmail.com"]
  spec.description   = "Ninefold CLI"
  spec.summary       = "The official ninefold CLI"
  spec.homepage      = "http://ninefold.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions    = ['ext/extconf.rb']

  spec.add_dependency "thor"
  spec.add_dependency "netrc"
  spec.add_dependency "faraday"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
end
