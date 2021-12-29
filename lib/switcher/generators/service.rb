require 'find'
require 'pathname'
require 'fileutils'
require 'structure'
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
              path = Pathname.new("#{service_path}/#{service_name}")
              base_dir_name = path.to_s              
              files = Dir.entries("#{base_dir_name}").reject { |file| file == ".." || file == "." }
              unless files.size < 1
                say(MESSAGES["output_msgs"]["files_to_remove"], :green)
                dirs = files.map { |file_name| file_name }.join(", ")
                say(dirs, :blue)
                response = ask(MESSAGES["queries"]["delete_services"], limited_to: OPTIONS)
                unless response == "n"
                  say("Deleting file#{'s' if dirs.size > 1}...", :red)
                  files.each do |dir|
                    FileUtils.remove_dir "#{base_dir_name}/#{dir}"
                    unless File.exists? "#{base_dir_name}/#{dir}"
                      say("Successfully removed #{dir}...", :green)
                    end
                  end

                  inside(service_name) do
                    define_app_dir_structure
                  end
                end
              end
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
 
