require_relative 'load_service'
module Switcher
  module Commands
    class LoadCommand < Thor::Group
      include Thor::Actions
      include Commands::LoadService
      argument :service_name, type: :string

      def load_service
        run_load_command
      end
    end
  end
end

