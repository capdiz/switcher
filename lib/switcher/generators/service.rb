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
          path = Pathname.new(curr_dir)
          inside_motherdir = path.children.each do |child|
            if child.directory? && child.basename.to_s == "services"
              break true
            end
          end

          if inside_motherdir.class.to_s == "Array"
            inside_servicedir = path.ascend do |dir|
              break true if dir.directory? && dir.basename == "services"
            end          
            if inside_servicedir.class.to_s == "Boolean" 
              return inside_servicedir
            else
              return false
            end
          else
            return inside_motherdir
          end
        end
      end        
    end
  end
end
 
