require "timecop"
require "rspec"
require 'webmock/rspec'

def with_time(time , &block)
  Timecop.freeze(time) do
    block.call
  end
end

def arrival_response(arrival_time)
  <<-RESPONSE
  <ctatt>
    <errCd>0</errCd>
    <eta>
      <arrT>#{arrival_time}</arrT>
    </eta>
  </ctatt>
  RESPONSE
end

def error_response
   <<-RESPONSE
   <ctatt>
     <errCd>101</errCd>
     <errNm>Invalid API key</errNm>
   </ctatt>
   RESPONSE
end

def stub_cta_train_request(api_key:, stpid:, response:)
  request_url = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{api_key}&stpid=#{stpid}"
  stub_request(:get, request_url).to_return(body: response)
end

def capture_output
   out = StringIO.new
   $stdout = out
   yield
   return out
ensure
   $stdout = STDOUT
end
