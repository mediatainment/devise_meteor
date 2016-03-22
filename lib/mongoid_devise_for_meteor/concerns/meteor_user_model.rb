module MongoidDeviseForMeteor
  module MeteorUserModel
    extend ActiveSupport::Concern

    included do
      # createdAt is needed, so we take regular timestamps and remap them
      include Mongoid::Timestamps

      # is used by mongoid_devise_for_meteor
      field :createdAt, type: Time
      # aliasing devise created_at to be able
      # to use it with meteors createdAt
      alias_attribute :created_at, :createdAt

      # An Array with hashes for emails
      field :emails, type: Array, default: []
      field :firstName, type: String, as: :first_name
      field :lastName, type: String, as: :last_name
      # profile relation
      embeds_one :profile, autobuild: true, class_name: "MongoidDeviseForMeteor::MeteorProfile"
      embeds_one :services, autobuild: true, class_name: "MongoidDeviseForMeteor::MeteorService"

      before_create :meteor_init
      before_validation :meteor_map_attributes

    end

    module ClassMethods

    end

    def name
      profile.name
    end

    def name=(name)
      profile.update_attribute(:name, name)
    end

    def username
      profile.username
    end

    def username=(username)
      profile.update_attribute(:username, username)
    end

    def meteor_get_hash_by_email(given_mail)
      used_mail = given_mail.nil? ? email : given_mail
      emails.detect { |mail| mail[:address] == used_mail }
    end

    # called by devise after confirmation is set
    def after_confirmation
      emails_temp = emails
      # we have to do this, by pop and re-adding because
      # MongoDb does not save when update within a nested array when is called by $set
      # So we pop our email out and overwrite the array completely
      # This approach does not work like expected which should update AND PERSIST, which does not work
      # User.where("emails.address" => email)
      # .set('emails.$.verified': true)
      hash = emails.pop { |m| m[:address] == email }
      hash[:verified] = true
      emails_temp << hash
      set(emails: emails_temp)
    end

    # Verifies whether a password (ie from sign in) is the user password.
    def valid_password?(password)
      Devise::Meteor::Encrypter.compare(password, encrypted_password)
    end

    def password_digest(password)
      Devise::Meteor::Encrypter.digest(password)
    end

    private

    # build a default password hash
    def build_meteor_password_hash(encrypted_password)
      {bcrypt: encrypted_password}
    end

    # maps current email to mongoid_devise_for_meteor emails: :address
    def meteor_map_email
      if attribute_changed?(:email) && email.present?
        existing_meteor_mail = meteor_get_hash_by_email(email)
        if existing_meteor_mail
          emails.delete(existing_meteor_mail)
          if existing_meteor_mail[:verified] == true
            new_mail = build_meteor_mail_hash(email, true)
            skip_confirmation!
          else
            new_mail = build_meteor_mail_hash(email, false)
          end
        else
          new_mail = build_meteor_mail_hash(email, false)
        end

        add_to_set(emails: new_mail)
      end
    end

    def meteor_map_name
      if attribute_changed?(:name) && name.present?
        name = first_name + " " + last_name
        profile.update_attribute(:name, name)
      end
    end

    # build a default email hash
    def build_meteor_mail_hash(email, verified_state)
      {address: email, verified: verified_state}
    end

    # remaps devise for mongoid_devise_for_meteor
    def meteor_map_attributes
      meteor_map_email
      meteor_map_name
      meteor_map_password
    end

    def meteor_init
      meteor_create_initial_email
    end

    # called when user is created
    def meteor_create_initial_email
      add_to_set(emails: build_meteor_mail_hash(email, confirmed?))
    end

    def meteor_map_password
      if (attribute_changed?(:encrypted_password) && encrypted_password.present?) ||
          (encrypted_password.nil? && !sessions.password[:bcrypt].nil?)

        password_hash = build_meteor_password_hash(encrypted_password)

        services.set(password: password_hash)

      elsif encrypted_password.nil?
        update_attribute!(:encrypted_password, services.password[:bcrypt])

      end
    end


  end
end