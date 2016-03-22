require "base64"
require "bcrypt"
require "openssl"

module DeviseMeteor
  class Hasher
    attr_reader :algorithm

    # Returns salt value to be used for hashing.
    #
    # @return [String] random salt value.
    def salt
      SecureRandom.hex(9)
    end

    # Returns if the given password match the encoded password.
    #
    # @param [String] password in plain text
    # @param [String] encoded password to be matched
    # @return [Boolean] if password match encoded password.
    def verify(password, encoded)
      raise NotImplementedError
    end

    # Returns given password encoded with the given salt.
    #
    # @param [String] password in plain text
    # @param [String] salt to be used during hashing
    # @return [String] given password hashed using the given salt
    def encode(password, salt)
      raise NotImplementedError
    end

    # Returns if given encoded password needs to be updated.
    #
    # @param [String] encoded password
    # @return [Boolean] if encoded password needs to be updated
    def must_update(encoded)
      false
    end

    private

    def constant_time_compare(a, b)
      check = a.bytesize ^ b.bytesize
      a.bytes.zip(b.bytes) { |x, y| check |= x ^ y }
      check == 0
    end
  end

# BCryptSHA256Hasher implements a BCrypt password hasher using SHA256.
  class BCryptSHA256Hasher < Hasher
    def initialize
      @algorithm = :bcrypt_sha256
      @cost = 10
      @digest = OpenSSL::Digest::SHA256.new
    end

    def salt
      BCrypt::Engine.generate_salt(@cost)
    end

    def get_password_string(password)
      @digest.digest(password) unless @digest.nil?
    end

    def encode(password, salt)
      password = get_password_string(password)
      hash = BCrypt::Engine.hash_secret(password, salt)
      return hash
    end

    def verify(password, encoded)
      password_digest = get_password_string(password)
      hash = BCrypt::Engine.hash_secret(password_digest, encoded)
      Devise.secure_compare(encoded, hash)

      constant_time_compare(encoded, hash)
    end

  end

# BCryptHasher implements a BCrypt password hasher.
  class BCryptHasher < BCryptSHA256Hasher
    def initialize
      @algorithm = :bcrypt
      @cost = 10
      @digest = nil
    end
  end
end
