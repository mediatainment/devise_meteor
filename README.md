# Mongoid Devise For Meteor

This gem provides a convenient way to connect your RailsApp to an existing Meteor app.

### What it does:

It saves the first matching `email` from meteors `emails`-Array into the `email` field which is used by devise.
It saves the `hash` from meteors `services.password.bcrypt` into the `encrypted_password`-field which is used by devise.
It confirms the devise user if the matching `email` was confirmed already in `meteor`.

## HELP NEEDED

### What it does not:

At the moment it is not possible to use the password generated by app `one` on app `two` and vice versa. I dont know why.
As you can see in the source, I have built a custom `Sha256`-class which should act like the meteor encrypt/decrypt process.
For any reason the comparison between the meteor generated bcrypt/sha256 password and the custom/devise generated one differs.

But for now, it's possible to generate a new one by using the default methods provided by devise.


## Requirements

1. You need an running Meteor server with the `accounts-password` library, ready setup and tested  
2. You need an running Rails app with mongoid as the default database up and running with `database_a_uthenticatable` 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid_devise_for_meteor'
```

And then execute:

    $ bundle install

Add change/add the new authentication strategy to your `initializers/devise.rb`.
It is already a placeholder near the bottom of the file:

 ```ruby
   # ==> Warden configuration
   # If you want to use other strategies, that are not supported by Devise, or
   # change the failure app, you can configure them inside the config.warden block.
   #
   config.warden do |manager|
     manager.strategies.add(:meteor, Devise::Strategies::Meteor)
     manager.default_strategies(scope: :user).unshift :meteor
   end
 ```


## Usage

Add the following after your field definitions in your `resource` (mostly the User model).

```ruby
  include MeteorUserModel
  # disable the mapping for the password simply use this line
  disable_meteor_mapping

```

This adds the profile and services relations are used by every meteor app which uses `accounts`.
Also the handling for password updates are made in this class.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mongoid_devise_for_meteor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

