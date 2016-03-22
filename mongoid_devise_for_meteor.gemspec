# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_devise_for_meteor/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid_devise_for_meteor"
  spec.version       = MongoidDeviseForMeteor::VERSION
  spec.authors       = ["Jan Jezek"]
  spec.email         = ["mail@mediatainment-productions.com"]

  spec.summary       = "Enables to authenticate devise on a meteor hosted mongoid server"
  spec.description   = "This app closes the gap between the huge world of ruby and meteor. Simply install, configure and use it to connect to the desired meteor server."
  spec.homepage      = "https://www.github.com/mediatainment/mongoid_devise_for_meteor"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.add_dependency('devise')

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
