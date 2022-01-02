module Switcher
  module CLI
    class Create < Thor
      desc "service SERVICE_NAME", "creates a new service"
      def service(service_name)      
        Service.start([service_name])
      end
    end
  end
end
