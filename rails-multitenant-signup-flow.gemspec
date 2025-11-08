# frozen_string_literal: true

require_relative "lib/rails_multitenant_signup_flow/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-multitenant-signup-flow"
  spec.version       = RailsMultitenantSignupFlow::VERSION
  spec.authors       = ["WToa"]
  spec.email         = ["will@wtoa.dev"]

  spec.summary       = "Generators for configuring a Rails multi-tenant signup flow with activerecord-tenanted."
  spec.description   = "Installs controllers, services, and configuration to enable multi-tenant authentication using activerecord-tenanted."
  spec.homepage      = "https://github.com/WToa/rails-multitenant-signup-flow"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.required_ruby_version = ">= 3.0.0"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      f.match?(%r{^(lib|README|LICENSE|CHANGELOG|MIT-LICENSE|Gemfile)})
    end
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord-tenanted", "~> 0.6", ">= 0.6.0"
  spec.add_development_dependency "minitest", "~> 5.20"
  spec.add_development_dependency "railties", ">= 7.0"
  spec.add_development_dependency "globalid", ">= 1.0"
end
