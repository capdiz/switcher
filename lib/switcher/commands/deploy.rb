require_relative "service_commands"
module Switcher
  module Commands
    class DeployCommand < Thor::Group
      include Thor::Actions
      include Commands::ServiceCommands
      argument :service_name, type: :string

      def create_deploy_command
        run_deploy_command
      end
    end
  end
end
