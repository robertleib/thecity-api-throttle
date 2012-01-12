module TheCity
  module Api
    module Throttle
  
      require 'rack/throttle'

      class Hourly < Rack::Throttle::Hourly
        
        def initialize(app, options = {})
          @client_identifier = options[:client_identifier]
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
            headers['X-City-RateLimit-Limit'] = max_per_window.to_s
            headers['X-City-RateLimit-Remaining'] = ([0, max_per_window - (cache_get(cache_key(request)).to_i rescue 1)].max).to_s
          end
          [status, headers, body]
        end
        
        def need_throttling?(request)
          return true if @ignore_path.blank?
          return !(request.env["REQUEST_PATH"] =~ Regexp.new(@ignore_path, true))
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
        
        def http_error(code, message = nil, headers = {})
          [code, {'Content-Type' => 'application/json; charset=utf-8'}.merge(headers), [{"error_code" => code, "error_message" => (message.nil? ? http_status(code) : message)}.to_json]]
        end

        def http_status(code)
          Rack::Utils::HTTP_STATUS_CODES[code]
        end
      end
  
    end
  end
end