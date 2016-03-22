require 'mongoid_devise_for_meteor/engine'


require "mongoid_devise_for_meteor/version"

require 'rails'

require 'mongoid_devise_for_meteor/railtie' if defined?(Rails)
require 'mongoid_devise_for_meteor/railtie'

require 'devise'
require 'mongoid_devise_for_meteor/encryption/devise_meteor_encrypter'
require 'mongoid_devise_for_meteor/encryption/devise_meteor_hasher'
require 'mongoid_devise_for_meteor/encryption/devise_meteor_strategy'

require 'mongoid_devise_for_meteor/concerns/meteor_user_model'

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
