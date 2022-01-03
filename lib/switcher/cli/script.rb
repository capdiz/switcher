module Switcher
  module CLI
    class Script
      U_R = 0400
      U_W = 0200
      U_X = 0100

      def make_executable(file)
        unless is_executable?(file)
          permissions = File.lstat("#{file}").mode | Script::U_R | Script::U_W | Script::U_X
          File.chmod(permissions, "#{file}")
        end
      end

      def add_load_command(load_script_path)
        open(load_script_path, 'a') do |command|
          command.puts 'echo "Loading merchants..."'
          command.puts 'echo "Switching to /home/capdiz/users/services/merchants..."'
          command.puts 'echo "home/capdiz/users/services/hello"'
        end
      end

      def add_deploy_command(deploy_script_path)
      end

      def add_run_test_command(run_test_script_path)
      end

      protected
      def is_executable?(file)
        File.executable?(file)
      end
    end
  end
end

