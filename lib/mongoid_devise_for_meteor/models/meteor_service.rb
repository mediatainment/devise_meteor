class MeteorService
  include Mongoid::Document

  embedded_in :user
  # to allow dynamic fields for the different authentication systems
  # otherwise the providers can be defined as field with type Hash
  # field :facebook, type: Hash
  # include Mongoid::Attributes::Dynamic
  field :facebook, type: Hash
  index({facebook: 1, 'facebook.authToken': 1})

  field :resume, type: Hash
  field :password, type: Hash
end