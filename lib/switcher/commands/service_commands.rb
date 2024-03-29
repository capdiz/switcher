module Switcher
  module Commands
    module ServiceCommands
      def run_load_command
        if inside_motherdir?
          if service_exists?
            Dir.chdir("#{service_path}/#{service_name}")
            say("Loaded #{Dir.getwd} as your current path..", :green)
            say("You can now deploy #{service_name} using 'switcher deploy #{service_name}'", :white)
          else
            say("Can't load service #{service_name}. Looks like it isn't an available service", :green)
          end
        else
          say("The 'switcher load service_name' command can only be called from inside a swutcher single-mother directory application.", :green)
          say("Run 'switcher motherdir APP_NAME' to create one", :white)
        end
      end

      def run_deploy_command
        if inside_motherdir?
          if service_exists?
            Dir.chdir("#{service_path}/#{service_name}")
            curr_dir = Dir.getwd
            inside(curr_dir) do
              run('bundle exec cap production deploy')
            end
          else
            say("Can't load service named #{service_name}. Looks like it isn't availbale within your services.", :green)            
          end
        else
          say("The 'switcher load SERVICE_NAME' command needs to be called from inside a single-mother directory application.", :white)
          say("Run 'switcher motherdir APP_NAME' to create a new switcher application", :white)          
        end
      end
      
      def run_start_service_command
        if inside_motherdir?
          if service_exists?
            Dir.chdir("#{service_path}/#{service_name}")
            curr_dir = Dir.getwd
            inside(curr_dir) do
              run('bundle exec rackup -p 3000')
            end
          else
            say("Can't start service named #{service_name}.")
          end
        else
          say("The 'switcher start SERVICE_NAME' command needs to be called from inside a single-mother directory application.", :white)
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
        curr_dir = Dir.getwd
        if curr_dir != Dir.home
          path = Pathname.new(curr_dir)
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
          return false
        end
      end

      def service_exists?
        File.exists?("#{service_path}/#{service_name}")
      end
    end
  end
end

