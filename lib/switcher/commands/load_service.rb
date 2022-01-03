require 'pathname'
module Switcher
  module Commands
    module LoadService
      def run_load_command
        puts "hello world"
        inside(config_path) do
          run("source ./load")
        end
      end

      def config_path
        if service_path_exists?
          config_dir = Dir.entries("#{service_path}").each do |dir|
            break File.absolute_path(dir) if File.basename(dir) == ".config"            
          end
        end
      end

      def service_dir_path
        curr_dir = Dir.getwd
        if curr_dir != Dir.home
          path = Pathname.new(curr_dir)
          services_dir = path.children.each do |child|
            break child if path.directory? && path.basename.to_s == "services"
          end

          if services_dir.class.to_s == "Pathname"
            return services_dir.to_s
          else
            services_dir = path.ascend do |dir|
              break dir if dir.directory? && dir.basename.to_s == "services"
            end
            return services_dir.to_s if services_dir.class.to_s == "Pathname"
          end
        end
      end

      def service_path_exists?
        File.exists?("#{service_dir_path}")
      end
    end
  end
end
