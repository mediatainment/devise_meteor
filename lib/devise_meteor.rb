require 'devise_meteor/engine'


require "devise_meteor/version"

require 'rails'

require 'devise_meteor/railtie' if defined?(Rails)
require 'devise_meteor/railtie'

require 'devise'
require 'devise_meteor/strategies/encrypter'
require 'devise_meteor/strategies/hasher'
require 'devise/strategies/meteor'

require 'devise_meteor/concerns/meteor_user_model'

module DeviseMeteor

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
