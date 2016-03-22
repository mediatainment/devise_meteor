module Devise
  module Meteor
    module Encrypter

      def self.digest(password)
        sha256_hasher = Devise::Meteor::BCryptSHA256Hasher.new
        sha256_hasher.encode(password, sha256_hasher.salt)
      end


      def self.compare(password, encrypted_password)
        sha256_hasher = Devise::Meteor::BCryptSHA256Hasher.new
        sha256_hasher.verify(password, encrypted_password)

      end
    end

  end
end