module DeviseMeteorAdapter
  def digest(klass, password)
    klass.pepper = nil
    password = ::Digest::SHA256.hexdigest(password)
    super
  end

  def compare(klass, hashed_password, password)
    klass.pepper = nil
    password = ::Digest::SHA256.hexdigest(password)
    super
  end
end

Devise::Encryptor.singleton_class.prepend(DeviseMeteorAdapter)