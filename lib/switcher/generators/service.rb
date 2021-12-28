require 'find'
module Switcher
  module Generators
    module Service
      OPTIONS = %w(y n).freeze

      def create_service
        if inside_motherdir?          
          if service_exists?
            say("A service already exists. Would you like to replace it?")
          end
        else
          say("Nothin found!", :green)
        end
      end

      def service_exists?
        File.exists?("#{service_path}/#{service_name}")
      end

      def service_path
        curr_dir = Dir.getwd
        path = Pathname.new(curr_dir)
        service_dir = path.children.each do |child|
          break child if child.directory? && child.basename.to_s == "services"
        end

        if service_dir.empty?
          service_dir = path.ascend do |dir|
            break dir if dir.directory? && dir.basename.to_s == "services"
          end
        end
        service_dir.to_s
      end

      def inside_motherdir?
        curr_dir = Dir.getwd
        if curr_dir != Dir.home
          service_dir_exists?(curr_dir)
        else
        say("The switcher create service command needs to be called when inside a swither application (a single-mother directory). \n If you haven't created one yet, run switcher motherdir app_name", :green)
        false
        end
      end

      def service_dir_exists?(curr_dir)
        path = Pathname.new(curr_dir)
        service_path = path.children.each do |child|
          break child if child.directory? && child.basename.to_s == "services"
        end

        if service_path.empty?
          # check backwards for a services folder
          service_path = path.ascend do |val|
            file = Pathname.new(val)
            break file if file.basename.to_s == "services"
          end
        end
        service_path.empty?
      end      
    end
  end
end
 
