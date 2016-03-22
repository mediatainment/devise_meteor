require 'rails'

require 'mongoid_devise_for_meteor/concerns/meteor_user_model'
require 'mongoid_devise_for_meteor/models/meteor_service'
require 'mongoid_devise_for_meteor/models/meteor_profile'

module MongoidCart
  class Railtie < Rails::Railtie

  end
end