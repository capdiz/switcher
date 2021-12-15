require_relative 'actions'
module Switcher
  module Generators
    class Motherdir < Thor::Group
      include Thor::Actions
      include Actions

      argument :motherdir_name, type: :string
      
      def create_group       
        create_motherdir_app
      end
    end
  end
end
