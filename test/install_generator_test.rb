# frozen_string_literal: true

require "test_helper"
require "rails/generators"
require "generators/rails_multitenant_signup_flow/install/install_generator"

class InstallGeneratorTest < Minitest::Test
  def generator_class
    RailsMultitenantSignupFlow::Generators::InstallGenerator
  end

  def test_inherits_from_rails_generators_base
    assert generator_class < Rails::Generators::Base
  end

  def test_force_option_defaults
    option = generator_class.class_options[:force]
    refute_nil option
    assert_equal :boolean, option.type
    refute option.default
  end

  def test_force_option_respected
    generator = generator_class.new([], { force: true })
    assert generator.send(:force?)
  end
end
