# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_listing_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_listing_rails"
  spec.version       = SimpleListingRails::VERSION
  spec.authors       = ["Pavel Shutsin"]
  spec.email         = ["publicshady@gmail.com"]
  spec.summary       = 'Simple classes for listing actions in your Rails app.'
  spec.description   = 'This gem provides easy and flexible way to write listing actions in your Rails app. It provides nice DSL for filtering, sorting and paginating in your listings.'
  spec.homepage      = "https://github.com/pluff/simple_listing_rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '~> 4.0'
  spec.add_dependency 'activesupport', '~> 4.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.2"
end
