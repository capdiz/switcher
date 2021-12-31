require_relative '../generators/service'
module Switcher
  module Generators
    class ServiceGenerator < Thor::Group
      include Thor::Actions
      include Switcher::Generators::Service
      argument :service_name, type: :string

      def create_switcher_service
        switch_dir
      end
    end
  end
end
