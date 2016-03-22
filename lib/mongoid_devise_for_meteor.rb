require 'rails'
require 'mongoid_devise_for_meteor/railtie' if defined?(Rails)
require "mongoid_devise_for_meteor/version"

module MongoidDeviseForMeteor

  # enable configuration
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :option

    def initialize
      @option = 'default_option'
    end
  end
end
