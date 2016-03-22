require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class Meteor < Authenticatable

      def valid?
        valid_for_params_auth? || valid_for_http_auth?
      end

      def authenticate!
        self.password = params_auth_hash[:password]

        # search for user email
        devise_resource = valid_for_params_auth? && mapping.to.find_for_database_authentication(authentication_hash)
        meteor_resource = User.where(:emails.elem_match => {address: params_auth_hash[:email]}).first unless devise_resource
        resource = devise_resource || meteor_resource

        return fail!(:not_found_in_database) unless resource

        # before continuing authentication process
        # check existing passwords and synchronize them
        if meteor_auth_missing?(resource)
          # when already devise credentials stored
          # assign them to mongoid_devise_for_meteor fields
          new_hashed_password = User.new(:password => password).encrypted_password
          resource.services.set(password: {bcrypt: new_hashed_password})

        elsif devise_auth_missing?(resource)
          # when user registered through mongoid_devise_for_meteor
          # and credentials for devise not present
          email = params_auth_hash[:email]
          crypt = resource.services.password[:bcrypt]

          unless resource.update_attributes(encrypted_password: crypt, email: email)
            fail(resource.unauthenticated_message)
          end
          resource.reload

        elsif both_auth_present?(resource)
          #when both passwords already set
        else
          return pass
        end

        # now do validation
        # this code is copied from Devise::Strategies::DatabaseAuthenticable
        encrypted = false
        if validate(resource) { encrypted = true; resource.valid_password?(password) }
          remember_me(resource)
          resource.after_database_authentication
          success!(resource)
        end

        mapping.to.new.password = password if !encrypted && Devise.paranoid
        fail(:not_found_in_database) unless resource
      end

      private

      def both_auth_present?(resource)
        has_a_meteor_password?(resource) && has_a_devise_password?(resource)
      end

      def devise_auth_missing?(resource)
        has_a_meteor_password?(resource) && !has_a_devise_password?(resource)
      end

      def meteor_auth_missing?(resource)
        has_a_devise_password?(resource) && !has_a_meteor_password?(resource)
      end

      def has_a_devise_password?(resource)
        resource.encrypted_password.present?
      end

      def has_a_meteor_password?(resource)
        resource.services.password.present?
      end

      # if you migrate from some other strategies than bcrypt
      def legacy_authenticates?(resource, password)
        # resource.encrypted_password == encrypt(resource, password)
      end

      def encrypt(resource, password)
        # some old encryption code
      end

    end
  end
end