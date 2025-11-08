# frozen_string_literal: true

require_relative "lib/rails_multitenant_signup_flow/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-multitenant-signup-flow"
  spec.version       = RailsMultitenantSignupFlow::VERSION
  spec.authors       = ["WToa"]
  spec.email         = ["support@example.com"]

  spec.summary       = "Generators for configuring a Rails multi-tenant signup flow with activerecord-tenanted."
  spec.description   = "Installs controllers, services, and configuration to enable multi-tenant authentication using activerecord-tenanted."
  spec.homepage      = "https://example.com/rails-multitenant-signup-flow"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.com/rails-multitenant-signup-flow"
  spec.metadata["changelog_uri"] = "https://example.com/rails-multitenant-signup-flow/changelog"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").select do |f|
      f.match?(%r{^(lib|README|LICENSE|CHANGELOG|MIT-LICENSE|Gemfile)})
    end
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord-tenanted"
end
