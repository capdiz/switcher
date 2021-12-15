require 'thor'
require 'find'
module Switcher
  module Scripts
    class Load < Thor::Group
     include Thor::Actions 
      U_R = 0400
      U_W = 0200
      U_X = 0100

      def load_file_exists?
        base_dir = Dir.getwd
        p Dir.entries(base_dir)
        path = Pathname.new("#{destination_root}")
        p path.basename
      end

      def append_to_file(file)
        open("#{file}", "a") { |f| f << "\nhello loader. welcome to chozishop \n" }
      end


    end
  end
end 
