module TheCity
  module Api
    module Throttle
  
      require 'rack/throttle'

      class ApiDefender < Rack::Throttle::Hourly
      end
  
    end
  end
end