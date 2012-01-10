module TheCity
  module Api
    module Throttle
  
      require 'rack/throttle'

      class Hourly < Rack::Throttle::Hourly
        
        def initialize(app, options = {})
          @client_identifier = option[:client_identifier]
          @ignore_path = options[:ignore_path]
          super
        end
        
        def allowed?(request)
          need_throttling?(request) ? super : true
        end
        
        def call(env)
          status, headers, body = super
          request = Rack::Request.new(env)

          if need_throttling?(request)
            headers['X-RateLimit-Limit'] = max_per_window.to_s
            headers['X-RateLimit-Remaining'] = ([0, max_per_window - (cache_get(cache_key(request)).to_i rescue 1)].max).to_s
          end
          [status, headers, body]
        end
        
        def need_throttling?(request)
          return false if (@ignore_path.present? and request.env["REQUEST_PATH"] =~ /"#{@ignore_path}"/i)
          return true
        end
        
        def client_identifier(request)
          identifier = case @client_identifier
          when :ip
            request.ip.to_s
          else
            request.env[@client_identifier]
          end
          return identifier || request.ip.to_s
        end
      end
  
    end
  end
end