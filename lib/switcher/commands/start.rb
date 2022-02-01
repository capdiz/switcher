module Switcher
  module Commands
    class Start < Thor::Group
      include Thor::Actions
      include Commands::ServiceCommands
      argument :service_name, type: :string

      def create_start_command
        run_start_service_command
      end
    end
  end
end
