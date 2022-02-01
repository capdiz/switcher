module Switcher
  module Exceptions
    class RequestException < StandardError
      attr_reader :valid_requests, :klass
      def initialize(valid_requests, klass, request_type)
        @valid_requests = valid_requests
        @klass = klass
        super("#{request_type} isn't a valid HTTP request method. Valid switcher request types are: #{request_type.map { |request| ":#{request}" }.join(", ")}")
      end        
    end
  end
end
