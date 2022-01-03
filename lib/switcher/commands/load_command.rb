require_relative 'load_service'
module Switcher
  module Commands
    class LoadCommand < Thor::Group
      include Thor::Actions
      include Commands::LoadService
      argument :service_name, type: :string

      def create_load_command
        puts service_name
        run_load_command
      end
    end
  end
end

