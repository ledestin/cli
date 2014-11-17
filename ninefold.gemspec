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

  spec.add_dependency "thor",     "0.19.1"
  spec.add_dependency "netrc",    "0.8.0"
  spec.add_dependency "json",     "1.8.1"
  spec.add_dependency "faraday",  "0.9.0"

  spec.add_development_dependency "bundler",  "~> 1.7"
  spec.add_development_dependency "rake",     "~> 10.3"
  spec.add_development_dependency "rspec",    "~> 3.1"
  spec.add_development_dependency "guard-rspec", "~> 4.3"
end
