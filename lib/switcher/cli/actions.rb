require "yaml"
require_relative "script"
require_relative "structure"
module Switcher
  module CLI
    module Actions
      include Structure
      OPTIONS = %w(y n).freeze
      MESSAGES = YAML.load_file(File.join(__dir__, "../scripts/prompts.yml")).freeze
      
      def create_motherdir_app
        if motherdir_exists?
          overwrite_motherdir
        else
          create_motherdir
        end
      end  

      def create_service
        if service_exists?(service_name)
        else
        end
      end

      protected
      def create_api
        if service_exists?
          say(MESSAGES["output_msgs"]["service_api_exists"], :green)
          query = ask(MESSAGES["queries"]["replace_service_query"], limited_to: OPTIONS)
          unless query == "n" 
          end
        else
        end
      end

      def overwrite_motherdir
        say(MESSAGES["output_msgs"]["motherdir_exists_msg"], :green)
        query = ask(MESSAGES["queries"]["replace_motherdir"], limited_to: OPTIONS)
        unless query == "n"
          inside(motherdir_name) do
            overwrite_load_script
            overwrite_deploy_script
            overwrite_run_test_script

            if services_dir_exists?
              path = Pathname.new("#{destination_root}/services")
              base_dir_name = path.to_s
              files = Dir.entries("#{base_dir_name}").reject { |file| file == ".." || file == "." }
              unless files.size < 1
                say(MESSAGES["output_msgs"]["services_dir_exists_msg"], :green)
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
                end
              end              
            end
          end
        end
      end

      def create_motherdir
        message = "Creating switcher single-mother directory #{motherdir_name}"
        say(message, :green)
        empty_directory(motherdir_name)
        inside(motherdir_name) do
          say("Creating services directory. This is where your APIs live...", :green)
       #   create_load_script
          #create_deploy_script
          #create_run_test_script
          say(MESSAGES["output_msgs"]["creating_service_dir_msg"], :green)
          empty_directory("services")
          query = ask(MESSAGES["queries"]["create_service"], limited_to: OPTIONS)
          unless query == "n"
            if services_dir_exists?
              create_load_script
              service_name = ask(MESSAGES["queries"]["service_name"])
              unless service_name.strip.empty?
                inside("services") do
                  empty_directory(service_name)
                  inside(service_name) do
                    init_gemfile
                    define_app_dir_structure
                    define_db_dir_structure
                    add_config_files
                  end
                end
              end
            end
          end
        end
      end

      def overwrite_load_script
        if load_script_exists?
          say(MESSAGES["output_msgs"]["deleting_load_script"], :red)
          File.delete("#{destination_root}/load")
          unless File.exists? "#{destination_root}/load"
            say(MESSAGES["output_msgs"]["deleted_load_script"], :green)
            create_load_script
          end
        else
          create_load_script
        end
      end

      def overwrite_deploy_script
        if deploy_script_exists?
          say(MESSAGES["output_msgs"]["deleting_deploy_script"], :red)
          File.delete("#{destination_root}/deploy")
          unless File.exists? "#{destination_root}/deploy"
            say(MESSAGES["output_msgs"]["deleted_deploy_script"], :green)
            create_deploy_script
          end
        else
          create_deploy_script
        end
      end

      def overwrite_run_test_script
        if run_test_script_exists?
          say(MESSAGES["output_msgs"]["deleting_run_test_script"], :red)
          File.delete("#{destination_root}/run_test")
          unless File.exists? "#{destination_root}/run_test"
            say(MESSAGES["output_msgs"]["deleted_run_test_script"], :green)
            create_run_test_script
          end
        else
          create_run_test_script
        end
      end
      
      def create_load_script
        inside("services") do
          FileUtils.mkdir(".config") 
          path = Pathname.new("#{destination_root}")
          config_folder = Dir.entries("#{path.to_s}").each do |dir|   
            break File.absolute_path(dir) if File.basename(dir) == ".config"
          end
          if config_dir_exists?(config_folder)
            inside(config_folder) do
              say(MESSAGES["output_msgs"]["load_script_msg"], :green)
              create_file "load", "#!usr/bin/env bash\n"
              file = "#{config_folder}/load"
              load_script = CLI::Script.new
              load_script.make_executable(file)
            end
          end
        end
      end


      def create_deploy_script
        say(MESSAGES["output_msgs"]["deploy_script_msg"], :green)
        create_file "deploy", "#!/usr/bin/env bash\n"
        if deploy_script_exists?
          file = "#{destination_root}/deploy"
          deploy_script = CLI::Script.new
          deploy_script.make_executable(file)
        end
      end

      def create_run_test_script
        say(MESSAGES["output_msgs"]["run_test_script_msg"], :green)
        create_file "run_test", "#!/usr/bin/env bash\n"
        if run_test_script_exists?
          file = "#{destination_root}/run_test"
          run_test_script = CLI::Script.new
          run_test_script.make_executable(file)
        end
      end

      def motherdir_exists?
        File.exists?("#{destination_root}/#{motherdir_name}")
      end

      def services_dir_exists?
        File.exists?("#{destination_root}/services")
      end
      
      def config_dir_exists?(path)
        File.exists?("#{path}")
      end


      def load_script_exists?
        File.exists?("#{destination_root}/load")
      end

      def deploy_script_exists?
        File.exists?("#{destination_root}/deploy")
      end

      def run_test_script_exists?
        File.exists?("#{destination_root}/run_test")
      end

      def service_exists?
        File.exists?("#{destination_root}/services/#{service_name}")
      end
    end
  end
end

