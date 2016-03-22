FactoryGirl.define do

  factory :user do
    #after(:build) { |u| u.password_confirmation = u.password = mypassword }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"

    factory :confirmed_user do
      confirmed_at Date.today
    end
  end

  factory :invalid_user, parent: :user do
    email { Faker::Internet.email }
    password "short"
    password_confirmation "short"
  end
end
