module Switcher
  module Scripts
    class Script
      DISPLAY_MSGS = { load_script_msg: "Creating load script..", deploy_script_msg: "Creating deploy script..", run_test_script_msg: "Creating run_test script.."  }.freeze
      MSG_COLORS = { creating: :yellow, exists: :red }.freeze

      # We shall not be making bash executable scripts since thor has a run command
      # that helps run commands without the need for us creating executable scripts.
      # U_R = 0400
      # U_W = 0200
      # U_X = 0100
      
      #
      # def make_executable(file)
      #  unless is_executable?(file)
      #    permissions = File.lstat("#{file}").mode | Script::U_R | Script::U_W | Script::U_W
      #    File.chmod(permissions, "#{file}")
      #  end
      # end
      
      # protected
      # def is_executable?(file)
      #  File.executable?(file)
      # end
    end
  end
end
