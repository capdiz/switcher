require 'thor'
require_relative 'cli/motherdir'
require_relative 'cli/create'
require_relative 'commands/load'
require_relative 'commands/deploy'
require_relative 'commands/start'

module Switcher
  module CLI
    class Cli < Thor      
      ENV['THOR_SILENCE_DEPRECATION'] = ""
      desc "motherdir APP_NAME", "I create a single mother directory"
      def motherdir(app_name)        
        Motherdir.start([app_name])              
      end

      desc "create SUBCOMMAND ...ARGS", "create's a service with a service name"
      subcommand "create", Switcher::CLI::Create

      desc "load SERVICE_NAME", "load's a service into path"
      def load(service_name)
        Commands::LoadCommand.start([service_name])
      end

      desc "deploy SERVICE_NAME", "deploy's a service current path to production"
      def deploy(service_name)
        Commands::Deploy.start([service_name])
      end

      desc "start SERVICE_NAME", "start's a switcher service in development"
      def start(service_name)
        Commands::Start.start([service_name])
      end
    end
  end
end
