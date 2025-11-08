# frozen_string_literal: true

require "test_helper"

class RailsMultitenantSignupFlowTest < Minitest::Test
  def test_module_exists
    assert defined?(::RailsMultitenantSignupFlow)
  end

  def test_has_version_number
    refute_nil ::RailsMultitenantSignupFlow::VERSION
  end

  def test_gemspec_uses_version_constant
    gemspec_path = File.expand_path("../rails-multitenant-signup-flow.gemspec", __dir__)
    spec = Gem::Specification.load(gemspec_path)
    refute_nil spec, "Expected gemspec to load from #{gemspec_path}"
    assert_equal ::RailsMultitenantSignupFlow::VERSION, spec.version.to_s
  end
end
