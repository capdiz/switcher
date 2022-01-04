require "yaml"
require_relative "../cli/script"
require_relative "structure"
module Switcher
  module Generators
    module MotherdirGenerator
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

      protected      
      def overwrite_motherdir
        say(MESSAGES["output_msgs"]["motherdir_exists_msg"], :green)
        query = ask(MESSAGES["queries"]["replace_motherdir"], limited_to: OPTIONS)
        unless query == "n"
          inside(motherdir_name) do          
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
          say(MESSAGES["output_msgs"]["creating_service_dir_msg"], :green)
          empty_directory("services")
          

          query = ask(MESSAGES["queries"]["create_service"], limited_to: OPTIONS)
          unless query == "n"
            if services_dir_exists?
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

      def motherdir_exists?
        File.exists?("#{destination_root}/#{motherdir_name}")
      end

      def services_dir_exists?
        File.exists?("#{destination_root}/services")
      end

      def service_exists?
        File.exists?("#{destination_root}/services/#{service_name}")
      end
    end
  end
end

