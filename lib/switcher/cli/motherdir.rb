require_relative "../generators/motherdir_generator"
module Switcher
  module CLI
    class Motherdir < Thor::Group
      include Thor::Actions
      include Generators::MotherdirGenerator
      argument :motherdir_name, type: :string

      def create_group
        create_motherdir_app
      end
    end
  end
end
