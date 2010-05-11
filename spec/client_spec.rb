require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  context "getting a record" do
    
    context "with an id for an existing record" do
      before do
        stub_request :get, 
          'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/5373629.json',
          :fixture_file => 'get_record.json'
        SimpleGeo::Client.set_credentials 'token', 'secret'
      end

      it "should return a single record with the correct attributes" do
        record = SimpleGeo::Client.get_record('com.simplegeo.global.geonames', 5373629)
        record.class.should == SimpleGeo::Record
        record.id.should == '5373629'
        record.type.should == 'place'
        record.layer.should == 'com.simplegeo.global.geonames'
        record.created.should == 1269832510
        record.lat.should == 37.759650000000001
        record.lon.should == -122.42608
        record.properties.should == {
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
  
    context "with an id for a nonexistant record" do
      before do
        stub_request :get, 
          'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/foo.json',gits
          
          :fixture_file => 'no_such_record.json', :status => 404
        SimpleGeo::Client.set_credentials 'token', 'secret'
      end
      
      it "should raise a NotFound exception" do
        lambda { 
          SimpleGeo::Client.get_record('com.simplegeo.global.geonames', 'foo')
        }.should raise_exception(SimpleGeo::NotFound)
      end
    end
    
  end
  
  context "adding a record" do
    before do
      stub_request :put,
              'http://api.simplegeo.com/0.1/records/io.path.testlayer/1234.json',
              :status => 202
      SimpleGeo::Client.set_credentials 'token', 'secret'
      # SimpleGeo::Client.set_credentials 'DJbRreDcp4Sn85PcGcP3gZMVJE8GkT7K', '3z46Ptcb6RKJennr39Suu9wT9AWLpCec'
      # SimpleGeo::Client.debug = true
    end

    it "should create the record" do
      record = SimpleGeo::Record.new({
        :id => '1234',
        :created => 1269832510,
        :lat => 37.759650000000001,
        :lon => -122.42608,
        :layer => 'io.path.testlayer',
        :properties => {
          :test_property => 'foobar'
        }
      })
      SimpleGeo::Client.add_record(record)
    end
    
  end
end 
  