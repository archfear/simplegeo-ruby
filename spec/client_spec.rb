require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  context "performing a request for a single record" do
    before do
      stub_request :get, 
        'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/5373629.json',
        :fixture_file => 'get_record.json'
      SimpleGeo::Client.set_credentials 'token', 'secret'
      @record = SimpleGeo::Client.get_record('com.simplegeo.global.geonames', 5373629)
    end

    it "should return a single Record with the correct attributes" do
      @record.class.should == SimpleGeo::Record
      @record.id.should == '5373629'
      @record.type.should == 'place'
      @record.created.should == 1269832510
      @record.lat.should == 37.759650000000001
      @record.lon.should == -122.42608
      @record.properties.should == {
        :layer => "com.simplegeo.global.geonames", 
        :elevation => "22", 
        :gtopo30 => "60", 
        :feature_code => "PRK", 
        :last_modified => "2006-01-15", 
        :country_code => "US", 
        :alternatenames => "", 
        :timezone => "America/Los_Angeles", 
        :population => "0", 
        :name => "Mission Dolores Park", 
        :feature_class => "L", 
        :cc2 => "", 
        :admin1 => "CA", 
        :admin3 => "", 
        :admin2 => "075", 
        :admin4 => "", 
        :asciiname => "Mission Dolores Park"
      }
    end
  end
end
