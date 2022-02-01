module Switcher
  module Dispatchers
    module RequestDispatcher
      DEFAULT_CALLS = %i(index show create update discard)
      HTTP_REQUESTS = %i(get post put patch delete all)
      
      def initiate_executors
        @executors_dispatcher = {}
      end

      def define_routes(&block)
        instance_eval(&block)
      end

      def route_for(model, request_type, executor, &block)
        (@executors_dispatcher[model] ||= []).push(request_type, executor) if !block_given?
        (@executors_dispatcher[model] ||= []).push(request_type, executor, block) if block_given?
      end 

      protected
      def dispatch(model, method, *args)
        if @executors_dispatcher[model]
          executor.call(method)
        end
      end
     
      def executor
        ->(executor_method) { executor_method }
      end
    end
  end
end

