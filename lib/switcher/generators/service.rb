require 'find'
require 'pathname'
module Switcher
  module Generators
    module Service
      OPTIONS = %w(y n).freeze
      MESSAGES = YAML.load_file(File.join(__dir__, "../scripts/prompts.yml"))

      def create_service
        if inside_motherdir?          
          if service_exists?
            say("A service named #{service_name} already exists.", :green)
            query = ask(MESSAGES["queries"]["replace_service"], limited_to: OPTIONS)
            unless query == "n"
              path = Pathname.new(service_path)
              base_dir_name = path.basename.to_s
              puts base_dir_name
            end
          end
        else
          say("Nothin found!", :green)
        end
      end
      
      def service_path
        curr_dir = Dir.getwd
        path = Pathname.new(curr_dir)
        service_dir = path.children.each do |child|
          break child if child.directory? && child.basename.to_s == "services"
        end

        if service_dir.class.to_s == "Pathname"
          return service_dir.to_s
        else
          service_dir = path.ascend do |dir|
            break dir if dir.directory? && dir.basename.to_s == "services"
          end

          return service_dir.to_s if service_dir.class.to_s == "Pathname"
        end
      end 

      def inside_motherdir?
        current_dir = Dir.getwd
        if current_dir != Dir.home
          path = Pathname.new(current_dir)
          motherdir = path.children.each do |child|
            break true if child.directory? && child.basename.to_s == "services"
          end

          if motherdir.class.to_s == "TrueClass"
            return motherdir
          else
            service_dir = path.ascend do |dir|
              break true if dir.directory? && dir.basename.to_s == "services"
            end
            if service_dir.class.to_s == "TrueClass"            
              return service_dir
            else
              return false
            end
          end
        else
        end
      end

      def service_exists?
        File.exists?("#{service_path}/#{service_name}")
      end            
    end
  end
end
 
