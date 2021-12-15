require_relative '../scripts/load'
require_relative '../scripts/script'
require_relative 'structure'
module Switcher
  module Generators
    module Actions
      include Structure
      OPTIONS = %w(y n).freeze
      ACTION_MESSAGES = {
        motherdir_msg: "A switcher application with the same single-mother directory name already exists?",
        motherdir_query: "Would you like to replace it?",
        services_msg: "A services directory already exists with the following APIs:",
        services_query: "The available APIs will be deleted. Would you like to proceed",
        creating_services_dir: "Creating services directory.."
      }.freeze

      QUERIES = { create_service: "Would you like to setup an API now? Note: you can do this later with the switcher create service command.",
                  service_name: "Enter your service name: ",
     replace_motherdir: "Would you like to replace it?",
     delete_services: "The available APIS will be deleted. Would you like to proceed?"  }.freeze

      def create_motherdir_app
        if motherdir_exists?          
          overwrite_motherdir
        else
          create_motherdir
        end
      end

      protected 
      def overwrite_motherdir
        say(ACTION_MESSAGES[:motherdir_msg], :green)
        query = ask(ACTION_MESSAGES[:motherdir_query], limited_to: OPTIONS)
        unless query == "n"
          inside(motherdir_name) do
            overwrite_load_script
            overwrite_deploy_script

            if services_dir_exists?             
              path = Pathname.new("#{destination_root}/services")
              base_dir_name = path.to_s

              files = Dir.entries("#{base_dir_name}").reject { |file| file == ".." || file == "." }
              unless files.size < 1
                say(ACTION_MESSAGES[:services_msg], :green)
                dirs = files.map { |file_name| file_name }.join(", ")
                say(dirs, :blue)
                response = ask(ACTION_MESSAGES[:services_query], limited_to: OPTIONS)
                unless response == "n"
                  say("Deleting file#{'s' if dirs.size > 1}..", :red)
                  files.each do |dir|
                    FileUtils.remove_dir "#{base_dir_name}/#{dir}"
                    unless File.exists? "#{base_dir_name}/#{dir}"
                      say("Successfully removed #{dir}..", :green)
                    end
                  end
                end
              end
            end
          end
        end
      end

      def create_motherdir
        message = "Creating swither single-mother directory #{motherdir_name}..."
        say(message)
        empty_directory(motherdir_name)
        inside(motherdir_name) do
          say("Creating services directory. This is where you application lives..")
          create_load_script
          create_deploy_script
          create_run_test_script
          say(ACTION_MESSAGES[:creating_services_dir], :green)
          empty_directory("services")
          query = ask(QUERIES[:create_service], limited_to: OPTIONS)
          unless query == "n"            
            if services_dir_exists?              
              service_name = ask(QUERIES[:service_name])              
              unless service_name.strip.empty? 
                inside("services") do
                  empty_directory(service_name)
                  inside(service_name) do
                    run('bundle init')
                    define_structure
                    if app_dir_exists?
                      inside("app") do
                        define_app_dir_structure
                      end
                    end

                    if config_dir_exists?
                      inside("config") do
                        define_config_dir_structure
                      end
                    end

                    if spec_dir_exists?
                      inside("spec") do
                        define_spec_dir_structure(service_name)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      def overwrite_load_script        
        if load_script_exists?
          say("Deleting load script..", :red)
          File.delete("#{destination_root}/load")
          unless File.exists? "#{destination_root}/load"
            say("Successfully deleted load script..", :green)         
            create_load_script
          end
        else
          create_load_script
        end
      end

      def overwrite_deploy_script
        if deploy_script_exists?
          say("Deleting deploy script..", :red)
          File.delete("#{destination_root}/deploy")
          unless File.exists? "#{destination_root}/deploy"
            say("Successfully deleted deploy script..", :green)
            create_deploy_script
          end
        else
          create_deploy_script
        end
      end
      
      def overwrite_run_test_script
        if run_test_script_exists?
          say("Deleting run_test script..", :red)
          File.delete("#{destination_root}/run_test")
          unless File.exists? "#{destination_root}/run_test"
            say("Successfully deleted run_test script..", :green)
            create_run_test_script
          end
        else
          create_run_test_script
        end
      end


      def create_load_script
       say(Switcher::Scripts::Script::DISPLAY_MSGS[:load_script_msg], Switcher::Scripts::Script::MSG_COLORS[:creating])      
       create_file "load", "#!/usr/bin/env bash\n"       
       if load_script_exists?
         file = "#{destination_root}/load"
         load_script = Switcher::Scripts::Script.new
         load_script.make_executable(file)        
       end
      end
       
      def create_deploy_script
        say(Switcher::Scripts::Script::DISPLAY_MSGS[:deploy_script_msg], Switcher::Scripts::Script::MSG_COLORS[:creating])   
        create_file "deploy", "#!/usr/bin/env bash\n"        
        if deploy_script_exists?          
          file = "#{destination_root}/deploy" 
          deploy_script = Switcher::Scripts::Script.new
          deploy_script.make_executable(file)
        end
      end

      def create_run_test_script
        say(Switcher::Scripts::Script::DISPLAY_MSGS[:run_test_script], Switcher::Scripts::Script::MSG_COLORS[:creating])
        create_file "run_test", "#!/usr/bin/env bash\n"
        if run_test_script_exists?
          file = "#{destination_root}/run_test"
          run_test_script = Switcher::Scripts::Script.new
          run_test_script.make_executable(file)
        end
      end

      def motherdir_exists?
        File.exists?("#{destination_root}/#{motherdir_name}")
      end

      def services_dir_exists?
        path = Pathname.new("#{destination_root}/services")
        path.directory?
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
    end
  end
end
