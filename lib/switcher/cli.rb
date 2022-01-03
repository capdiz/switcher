require 'thor'
require_relative 'cli/motherdir'
require_relative 'cli/create'
require_relative 'commands/load'

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

      desc "load ...ARGS", "load's a service into path"
      subcommand "load", Switcher::Commands::Load

    end
  end
end
