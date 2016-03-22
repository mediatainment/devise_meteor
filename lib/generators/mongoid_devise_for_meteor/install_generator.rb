module MongoidDeviseForMeteor
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates initializer for meteor specific config"

      def copy_initializer
        template "meteor_initializer.rb", "config/initializers/meteor.rb"

        puts "Added initializer to your app."
      end
    end
  end
end