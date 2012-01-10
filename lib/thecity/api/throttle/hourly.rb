module TheCity
  module Api
    module Throttle
  
      require 'rack/throttle'

      class Hourly < Rack::Throttle::Hourly
        
        def initialize(app, options = {})
          super
        end
        
        def allowed?(request)
          need_throttling?(request) ? cache_incr(request) <= max_per_window : true
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
          return false if request.env["REQUEST_PATH"] =~ /^\/$|^\/accounts|^\/keys/i
          return true
        end
        
        def client_identifier(request)
          request.env['X_CITY_USER_ID'] || request.env['HTTP_X_CITY_USER_ID'] || request.ip.to_s
        end
      end
  
    end
  end
end