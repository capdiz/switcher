require_relative '../generators/service_generator'
module Switcher
  module CLI
    class Service < Thor::Group
      include Thor::Actions
      include Generators::ServiceGenerator
      argument :service_name, type: :string

      def create_switcher_service
        create_service
      end
    end
  end
end

