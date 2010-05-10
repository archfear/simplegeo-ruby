require 'test_helper'

class ClientTest < Test::Unit::TestCase
  
  context "performing a request for a single record" do
    setup do
      stub_request :get, 
        'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/5373629.json',
        :fixture_file => 'get_record.json'
      SimpleGeo::Client.set_credentials 'token', 'secret'
      SimpleGeo::Client.debug = true
      @object = SimpleGeo::Client.get_record('com.simplegeo.global.geonames', 5373629)
    end

    should "return a single JSON object" do
      @object.class.should be(Hash)
    end
  end
  
end
