require_relative '../generators/service_generator'
module Switcher
  module CLI
    class Create < Thor
      desc "service SERVICE_NAME", "creates a new service"
      def service(service_name)      
        Switcher::Generators::ServiceGenerator.start([service_name])
      end
    end
  end
end
