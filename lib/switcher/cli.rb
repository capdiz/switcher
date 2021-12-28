require 'thor'
require_relative 'cli/motherdir'
require_relative 'cli/create'

module Switcher
  module CLI
    class Cli < Thor      
      ENV['THOR_SILENCE_DEPRECATION'] = ""
      desc "motherdir APP_NAME", "I create a single mother directory"
      def motherdir(app_name)        
        Motherdir.start([app_name])              
      end

      desc "load SERVICE_NAME", "loads service directory as currently working directory"
     def load(service_name)
       
     end 

      desc "create SUBCOMMAND ...ARGS", "create's a service with a service name"
      subcommand "create", Switcher::CLI::Create
    end
  end
end
