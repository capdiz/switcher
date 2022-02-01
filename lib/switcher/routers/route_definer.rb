require_relative "../exceptions/request_exception"
module Switcher
  module Routers
    module RouteDefiner
      include Exceptions
      @@mapped_routes ||= []
      HTTP_REQUESTS = [:get, :post, :put, :patch, :delete, :all].freeze
      DEFAULT_METHOD
      
      def define_routes(&block)
        instance_eval(&block)
      end

      def route_for(model, request_type, executor, &block)
        has_nested_route = false unless block_given?
        map_route = { model: model, request_type: request_type, executor: executor, has_nested_routes: has_nested_route }
        @@mapped_routes << map_route
      end

         
      class Request
        attr_accessor :model, :request_type, :executor

        def initialize(model, request_type, executor)
          @model = model
          @request_type = request_type
          @executor = executor
        end

        def nested_request_url
          raise Exceptions::RequestException.new(self, HTTP_REQUESTS, request_type) if !valid_request_type?

        end

        def non_nested_requested_url
          raise Exceptions::RequestException.new(self, HTTP_REQUEST, request_type) if !valid_request_type?
        end

        def non_nested_request(&block)
        end

        #protected
        def define_nested_request_url
        end

        def define_non_nested_request_url
        end

        def valid_request_type?
          HTTP_REQUESTS.include?(request_type)
        end

        def valid_model?
        end

        def valid_executor?
        end
      end
    end
  end
end
