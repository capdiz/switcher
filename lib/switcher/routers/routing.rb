module Switcher
  module Routers
    class << self
      def app
        self.new
      end
    end
  end
end
