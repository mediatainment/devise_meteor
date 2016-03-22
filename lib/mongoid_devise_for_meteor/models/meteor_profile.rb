class MeteorProfile
  include Mongoid::Document

  embedded_in :user

  field :name, type: String
  field :username, type: String
  field :firstName, type: String
  field :lastName, type: String
end