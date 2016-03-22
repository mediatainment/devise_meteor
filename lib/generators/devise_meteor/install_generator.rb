module DeviseMeteor
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates initializer for devise_meteor specific config"

      def copy_initializer
        template "meteor_initializer.rb", "config/initializers/devise_meteor.rb"

        puts "Added initializer to your app."
      end
    end
  end
end