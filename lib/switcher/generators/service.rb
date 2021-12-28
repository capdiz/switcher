require 'find'
require 'pathname'

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

      def inside_motherdir?
        current_dir = Dir.getwd
        if current_dir != Dir.home
          path = Pathname.new(current_dir)
          motherdir = path.children.each do |child|
            break true if child.directory? && child.basename.to_s == "services"
          end

          if motherdir.class.to_s == "Boolean"
            return motherdir
          else
            service_dir = path.ascend do |dir|
              break true if dir.directory? && dir.basename.to_s == "services"
            end
            if service_dir.class.to_s == "Boolean"
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
    end
  end
end
 
