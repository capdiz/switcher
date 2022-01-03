require_relative 'load_command'

module Switcher
  module Commands
    class Load < Thor 
      desc "load SERVICE_NAME", "loads a service into path"
      def load(service_name)
        Commands::LoadCommand.start([service_name])
      end
    end
  end
end
