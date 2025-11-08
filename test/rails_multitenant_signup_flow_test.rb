# frozen_string_literal: true

require "test_helper"

class RailsMultitenantSignupFlowTest < Minitest::Test
  def test_module_exists
    assert defined?(::RailsMultitenantSignupFlow)
  end

  def test_has_version_number
    refute_nil ::RailsMultitenantSignupFlow::VERSION
  end
end
