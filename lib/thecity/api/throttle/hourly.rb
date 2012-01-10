module Thecity; module api; module throttle
  
  require 'rack/throttle'

  class ApiDefender < Rack::Throttle::Hourly
  end
  
end; end; end