module MongoidDeviseForMeteor
  class MeteorProfile
    include Mongoid::Document

    embedded_in :user

    field :name, type: String, default: ""
    field :username, type: String, default: ""
    field :firstName, type: String, default: ""
    field :lastName, type: String, default: ""
  end
end