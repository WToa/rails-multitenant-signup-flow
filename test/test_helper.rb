# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "active_support/core_ext/module/delegation"
require "rails/railtie"
require "active_support/string_inquirer"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

module Rails
	class << self
		attr_writer :_env_for_tests
	end

	def self.env
		@_env_for_tests ||= ActiveSupport::StringInquirer.new("test")
	end
end

require "rails_multitenant_signup_flow"
