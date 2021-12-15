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

      protected
      def is_executable?(file)
        File.executable?(file)
      end
    end
  end
end

