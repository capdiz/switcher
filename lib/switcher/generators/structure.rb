module Switcher
  module Generators
    module Structure
      def define_structure
        FileUtils.mkdir("app")
        FileUtils.mkdir("config")
        FileUtils.mkdir("db")
        FileUtils.mkdir("spec")
      end

      def define_app_dir_structure
        FileUtils.touch("app.rb")
        FileUtils.mkdir("models")
        FileUtils.mkdir("controllers")
      end

      def define_config_dir_structure
        FileUtils.touch("router.rb")
        FileUtils.touch("deploy.rb")
        FileUtils.touch("db.yml")
      end

      def define_spec_dir_structure(service_name)
        FileUtils.touch("#{service_name}_spec.rb")
      end

      def app_dir_exists?
        File.exists?(File.expand_path("app", destination_root))
      end

      def config_dir_exists?
        File.exists?(File.expand_path("config", destination_root))
      end

      def spec_dir_exists?
        File.exists?(File.expand_path("spec", destination_root))
      end
    end
  end
end
