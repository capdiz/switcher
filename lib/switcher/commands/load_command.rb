require_relative 'service_commands'
module Switcher
  module Commands
    class LoadCommand < Thor::Group
      include Thor::Actions
      include Commands::ServiceCommands
      argument :service_name, type: :string

      def create_load_command
        run_load_command
      end
    end
  end
end

