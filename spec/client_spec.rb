require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  before do
    SimpleGeo::Client.set_credentials 'token', 'secret'
  end
  
  context "getting a record" do
    context "with an id for an existing record" do
      before do
        stub_request :get, 
          'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/5373629.json',
          :fixture_file => 'get_record.json'
      end

      it "should return a single record with the correct attributes" do
        record = SimpleGeo::Client.get_record('com.simplegeo.global.geonames', 5373629)
        record.class.should == SimpleGeo::Record
        record.id.should == '5373629'
        record.type.should == 'place'
        record.layer.should == 'com.simplegeo.global.geonames'
        record.created.should == Time.at(1269832510)
        record.lat.should == 37.759650000000001
        record.lon.should == -122.42608
        record.properties.should == {
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
  
    context "with an id for a nonexistant record" do
      before do
        stub_request :get, 
          'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/foo.json',
          :fixture_file => 'no_such_record.json', :status => 404
      end
      
      it "should raise a NotFound exception" do
        lambda { 
          SimpleGeo::Client.get_record('com.simplegeo.global.geonames', 'foo')
        }.should raise_exception(SimpleGeo::NotFound)
      end
    end
  end
  
  #TODO: verify request data contains correct record data
  context "adding/updating a record" do
    before do
      stub_request :put,
        'http://api.simplegeo.com/0.1/records/io.path.testlayer/1234.json',
        :status => 202
    end

    it "should create or update the record" do
      lambda {
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
      }.should_not raise_exception
    end
  end
  
  context "deleting a record" do
    before do
      stub_request :delete,
        'http://api.simplegeo.com/0.1/records/io.path.testlayer/1234.json',
        :status => 202
    end

    it "should delete the record" do
      lambda {
        SimpleGeo::Client.delete_record('io.path.testlayer', '1234')
      }.should_not raise_exception
    end
  end
  
  context "getting multiple records" do
    context "with ids for two existing records" do
      before do
        stub_request :get, 
          'http://api.simplegeo.com/0.1/records/com.simplegeo.us.business/41531696,41530629.json',
          :fixture_file => 'get_records.json'
      end

      it "should return an array of records with the correct attributes" do
        records = SimpleGeo::Client.get_records('com.simplegeo.us.business', ['41531696', '41530629'])
        records.size.should == 2
        records[0].id.should == '41530629'
        records[0].type.should == 'place'
        records[0].layer.should == 'com.simplegeo.us.business'
        records[0].created.should == Time.at(1271985142)
        records[0].lat.should == 37.760350000000003
        records[0].lon.should == -122.419043
        records[0].properties.should == {
          :state => "CA",
          :census_block_group => "2",
          :street_type => "St",
          :city => "San Francisco",
          :census_block_id => "002",
          :plus4 => "1811",
          :cbsa => "41860",
          :time_zone => "4",
          :censustract => "020800",
          :pubdate => "2009-12-01",
          :std_name => "Beauty Bar",
          :phone_number => "0323",
          :state_fips => "06",
          :company_sics => [
            {
              :sic => "72310000", 
              :industry_class => "7", 
              :relevancy => "1", 
              :naics_description => "BEAUTY SALONS",
              :naics => "812112",
              :sic_4 => "7231",
              :description => "BEAUTY SHOPS",
              :sic_4_description => "BEAUTY SHOPS"
            }, 
            { 
              :sic => "58130101",
              :industry_class => "5",
              :relevancy => "2",
              :naics_description => "DRINKING PLACES (ALCOHOLIC BEVERAGES)",
              :naics => "72241",
              :sic_4 => "5813",
              :description => "BAR (DRINKING PLACES)",
              :sic_4_description => "DRINKING PLACES"
            },
            { 
              :sic => "58120310",
              :industry_class => "5",
              :relevancy => "3",
              :naics_description => "LIMITED-SERVICE RESTAURANTS",
              :naics => "722211",
              :sic_4 => "5812",
              :description => "GRILLS, ( EATING PLACES)",
              :sic_4_description => "EATING PLACES"
            }
          ], 
          :dpv_confirm => "Y",
          :zip => "94110",
          :dpc => "996",
          :street_name => "Mission",
          :carrier_route => "C036",
          :area_code => "415",
          :company_headings => [
            { 
              :category_name => "Bars, Taverns & Cocktail Lounges",
              :condensed_name => "BARS GRILLS & PUBS",
              :normalized_id => "138001000",
              :category_id => "138000000",
              :normalized_name => "BARS GRILLS & PUBS",
              :condensed_id => "138001000"
            }
          ],
          :mlsc => "4",
          :val_date => "2010-03-22",
          :confidence_score => "100",
          :exppubcity => "San Francisco",
          :housenumber => "2299",
          :z4_type => "S",
          :exchange => "285",
          :business_name => "Beauty Bar",
          :county_fips => "075",
          :ll_match_level => "R",
          :dso => "1",
          :company_phones => [
            { 
              :val_flag => "C",
              :val_date => "2010-03-22",
              :phone_type => "P",
              :dnc => "",
              :exchange => "285",
              :phone_number => "0323",
              :areacode => "415"
            }
          ], 
          :msa => "7360",
          :val_flag => "C"
        }
        records[1].id.should == '41531696'
        records[1].type.should == 'place'
        records[1].layer.should == 'com.simplegeo.us.business'
        records[1].created.should == Time.at(1271985146)
        records[1].lat.should == 37.755470000000003
        records[1].lon.should == -122.420646
        records[1].properties.should == {
          :carrier_route => "C010", 
          :pubdate => "2009-12-01", 
          :ll_match_level => "R", 
          :street_name => "22nd", 
          :std_name => "Latin American Club", 
          :val_flag => "C", 
          :census_block_id => "004", 
          :company_headings => [
            {
              :normalized_id => "138004000", 
              :condensed_name => "NIGHT CLUBS", 
              :condensed_id => "138004000", 
              :normalized_name => "NIGHT CLUBS", 
              :category_id => "138000000", 
              :category_name => "Bars, Taverns & Cocktail Lounges"
            }
          ], 
          :company_sics => [
            {
              :sic_4 => "5813", 
              :relevancy => "1", 
              :description => "NIGHT CLUBS", 
              :naics => "72241", 
              :sic => "58130200", 
              :industry_class => "5", 
              :sic_4_description => "DRINKING PLACES", 
              :naics_description => "DRINKING PLACES (ALCOHOLIC BEVERAGES)"
            }
          ], 
          :city => "San Francisco", 
          :county_fips => "075", 
          :zip => "94110", 
          :mlsc => "4", 
          :dso => "1", 
          :state => "CA", 
          :dpv_confirm => "Y", 
          :housenumber => "3286", 
          :msa => "7360", 
          :phone_number => "2732", 
          :exchange => "647", 
          :area_code => "415", 
          :censustract => "020800", 
          :state_fips => "06", 
          :street_type => "St", 
          :business_name => "Latin American Club", 
          :plus4 => "3033", 
          :val_date => "2010-03-22", 
          :dnc => "T", 
          :confidence_score => "100", 
          :time_zone => "4", 
          :cbsa => "41860", 
          :dpc => "862", 
          :company_phones => [
            {
              :phone_number => "2732", 
              :phone_type => "P", 
              :val_date => "2010-03-22", 
              :dnc => "T", 
              :exchange => "647", 
              :areacode => "415", 
              :val_flag => "C"
            }
          ], 
          :census_block_group => "4", 
          :z4_type => "S"
        }
      end
    end
  
    context "with ids for nonexistant records" do
      before do
        stub_request :get, 
          'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/foo,bar.json',
          :fixture_file => 'nonetype_not_iterable.json', :status => 500
      end
      
      it "should raise a NotFound exception" do
        lambda { 
          SimpleGeo::Client.get_records('com.simplegeo.global.geonames', ['foo', 'bar'])
        }.should raise_exception(SimpleGeo::ServerError)
      end
    end
  end

  context "adding multiple records" do
    before do
      stub_request :post,
        'http://api.simplegeo.com/0.1/records/io.path.testlayer.json',
        :status => 202
    end

    it "should create or update the record" do
      layer = 'io.path.testlayer'
      lambda {
        records = [
          SimpleGeo::Record.new({
            :id => '1234',
            :created => 1269832510,
            :lat => 37.759650000000001,
            :lon => -122.42608,
            :layer => layer,
            :properties => {
              :test_property => 'foobar'
            }
          }),
          SimpleGeo::Record.new({
            :id => '5678',
            :created => 1269832510,
            :lat => 37.755470000000003,
            :lon => -122.420646,
            :layer => layer,
            :properties => {
              :mad_prop => 'baz'
            }
          })
        ]
        SimpleGeo::Client.add_records(layer, records)
      }.should_not raise_exception
    end
  end

  context "getting a record's history" do
    before do
      stub_request :get,
        'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/5373629/history.json',
        :fixture_file => 'get_history.json'
    end

    it "should create or update the record" do
      history = SimpleGeo::Client.get_history('com.simplegeo.global.geonames', '5373629')
      history.should == [
        { 
          :created => Time.at(1269832510),
          :lat => 37.759650000000001,
          :lon => -122.42608
        }
      ]
    end
  end
  
  context "getting nearby records" do
    before do      
      @expected_records = {
        :next_cursor => "QVSEifz7gri4J0w8FSQJ06Z5S5lOw6gZ75Co-fBbBQJEr7XMqN32bjMKNc9kwLKqKyqtVvxR_t5hgWW6XDgPnPTY",
        :records => [
          {
            :distance => 0,
            :record => SimpleGeo::Record.new(
              :id => "5373629",
              :lon => -122.42608,
              :lat => 37.75965,
              :type => "place",
              :layer => "com.simplegeo.global.geonames",
              :created => Time.at(1269832510),
              :properties => {
                :admin4 => "",
                :feature_code => "PRK",
                :feature_class => "L",
                :last_modified => "2006-01-15",
                :asciiname => "Mission Dolores Park",
                :cc2 => "",
                :country_code => "US",
                :admin1 => "CA",
                :alternatenames => "",
                :admin3 => "",
                :elevation => "22",
                :layer => "com.simplegeo.global.geonames",
                :timezone => "America/Los_Angeles",
                :name => "Mission Dolores Park",
                :gtopo30 => "60",
                :admin2 => "075",
                :population => "0"
              }
            )
          },
          {
            :distance => 57.557068918956581,
            :record => SimpleGeo::Record.new(
              :id => "5352852",
              :lon => -122.42553,
              :lat => 37.75937,
              :type => "place",
              :layer => "com.simplegeo.global.geonames",
              :created => Time.at(1269832039),
              :properties => {
                :admin4 => "",
                :feature_code => "CH",
                :feature_class => "S",
                :last_modified => "2006-01-15",
                :asciiname => "Golden Gate Lutheran Church",
                :cc2 => "",
                :country_code => "US",
                :admin1 => "CA",
                :alternatenames => "",
                :admin3 => "",
                :elevation => "23",
                :layer => "com.simplegeo.global.geonames",
                :timezone => "America/Los_Angeles",
                :name=> "Golden Gate Lutheran Church",
                :gtopo30 => "60",
                :admin2 => "075",
                :population => "0"
              }
            )
          }
        ]
      }
    end
    
    context "by lat and lon" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/nearby/37.75965,-122.42608.json',
          :fixture_file => 'get_nearby.json'
      end
      
      it "should return a hash of nearby records" do
        records = SimpleGeo::Client.get_nearby_records('com.simplegeo.global.geonames', 
          :lat => 37.759650000000001,
          :lon => -122.42608)
        records.should == @expected_records
      end
    end
    
    context "by geohash" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/0.1/records/com.simplegeo.global.geonames/nearby/9q8yy1ujcsfm.json',
          :fixture_file => 'get_nearby.json'
      end
      
      it "should return a hash of nearby records" do
        records = SimpleGeo::Client.get_nearby_records('com.simplegeo.global.geonames', 
          :geohash => '9q8yy1ujcsfm')
        records.should == @expected_records
      end
    end
  end
  
  context "getting nearby addresses" do
    before do
      stub_request :get,
        'http://api.simplegeo.com/0.1/nearby/address/37.75965,-122.42608.json',
        :fixture_file => 'nearby_address.json'
    end

    it "should return a hash with the address information" do
      nearby_addresses = SimpleGeo::Client.get_nearby_address(37.759650000000001, -122.42608)
      nearby_addresses.should == { 
        :state_name => "California", 
        :street_number => "580", 
        :country => "US", 
        :street => "Dolores St", 
        :postal_code => "", 
        :county_name => "San Francisco", 
        :county_code => "075", 
        :state_code => "CA", 
        :place_name => "San Francisco"
      }
    end
  end
  
  context "getting layer information" do
    context "for an existing layer" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/0.1/layer/io.path.testlayer.json',
          :fixture_file => 'layer_info.json'
      end
      
      it "should return a hash containing the layer information" do
        layer_info = SimpleGeo::Client.get_layer_information('io.path.testlayer')
        layer_info.should == {
          :name => "io.path.testlayer",
          :public => false,
          :callback_urls => []
        }
      end
    end
    
    context "for a nonexistant layer" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/0.1/layer/io.path.testlayer.json',
          :status => 404
      end
      
      it "should raise a NotFound exception" do
        lambda {
          SimpleGeo::Client.get_layer_information('io.path.testlayer')
        }.should raise_exception(SimpleGeo::NotFound)
      end
    end
  end
  
  context "getting SpotRank information for a day, hour and location" do
    before do
      stub_request :get,
        'http://api.simplegeo.com/0.1/density/sat/16/37.75965,-122.42608.json',
        :fixture_file => 'get_density_by_hour.json'
    end
    
    it "should return a hash containing the density information" do
      density_info = SimpleGeo::Client.get_density(37.75965, -122.42608, 'sat', '16' )
      density_info.should == {
        :city_rank => 10,
        :local_rank => 8,
        :trending_rank => 0,
        :dayname => "sat",
        :hour => 16,
        :worldwide_rank => 8,
        :geometry => {
          :type => "Polygon",
          :coordinates => [
            [ 37.7587890625, -122.4267578125 ],
            [ 37.759765625, -122.4267578125 ],
            [ 37.759765625, -122.42578125 ],
            [ 37.7587890625, -122.42578125 ],
            [ 37.7587890625, -122.4267578125 ]
          ]
        }
      }
    end
  end
  
  context "getting SpotRank information for a day and location" do
    before do
      stub_request :get,
        'http://api.simplegeo.com/0.1/density/sat/37.75965,-122.42608.json',
        :fixture_file => 'get_density_by_day.json'
    end
    
    it "should return an array of hashes containing the density information" do
      density_info = SimpleGeo::Client.get_density(37.75965, -122.42608, 'sat')
      density_info.should == [
        {
          :geometry => {
            :type => "Polygon",
            :coordinates => [
              [ 37.7587890625, -122.4267578125 ],
              [ 37.759765625, -122.4267578125 ],
              [ 37.759765625, -122.42578125 ],
              [ 37.7587890625, -122.42578125 ],
              [ 37.7587890625, -122.4267578125 ]
            ]
          }, 
          :hour => 0, 
          :trending_rank => 2, 
          :local_rank => 4, 
          :city_rank => 10, 
          :worldwide_rank => 4, 
          :dayname => "sat"
        }, 
        {
          :geometry => {
            :type => "Polygon",
            :coordinates => [
              [ 37.7587890625, -122.4267578125 ],
              [ 37.759765625, -122.4267578125 ],
              [ 37.759765625, -122.42578125 ],
              [ 37.7587890625, -122.42578125 ],
              [ 37.7587890625, -122.4267578125 ]
            ]
          }, 
          :hour => 1, 
          :trending_rank => -2, 
          :local_rank => 6, 
          :city_rank => 10, 
          :worldwide_rank => 6, 
          :dayname => "sat"
        }, 
        {
          :geometry => {
            :type => "Polygon",
            :coordinates => [
              [ 37.7587890625, -122.4267578125 ],
              [ 37.759765625, -122.4267578125 ],
              [ 37.759765625, -122.42578125 ],
              [ 37.7587890625, -122.42578125 ],
              [ 37.7587890625, -122.4267578125 ]
            ]
          }, 
          :hour => 2, 
          :trending_rank => 2, 
          :local_rank => 2, 
          :city_rank => 10, 
          :worldwide_rank => 2, 
          :dayname => "sat"
        }, 
        {
          :geometry => {
            :type => "Polygon",
            :coordinates => [
              [ 37.7587890625, -122.4267578125 ],
              [ 37.759765625, -122.4267578125 ],
              [ 37.759765625, -122.42578125 ],
              [ 37.7587890625, -122.42578125 ],
              [ 37.7587890625, -122.4267578125 ]
            ]
          }, 
          :hour => 3, 
          :trending_rank => -2, 
          :local_rank => 6, 
          :city_rank => 10, 
          :worldwide_rank => 6, 
          :dayname => "sat"
        }, 
        {
          :geometry => {
            :type => "Polygon",
            :coordinates => [
              [ 37.7587890625, -122.4267578125 ],
              [ 37.759765625, -122.4267578125 ],
              [ 37.759765625, -122.42578125 ],
              [ 37.7587890625, -122.42578125 ],
              [ 37.7587890625, -122.4267578125 ]
            ]
          }, 
          :hour => 4, 
          :trending_rank => -2, 
          :local_rank => 4, 
          :city_rank => 10, 
          :worldwide_rank => 4, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 6, 
          :trending_rank => 2, 
          :local_rank => 2, 
          :city_rank => 10, 
          :worldwide_rank => 2, 
          :dayname => "sat"
        }, 
        {
          :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 7, 
          :trending_rank => 1, 
          :local_rank => 5, 
          :city_rank => 10, 
          :worldwide_rank => 5, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 8, 
          :trending_rank => 0, 
          :local_rank => 6, 
          :city_rank => 10, 
          :worldwide_rank => 6, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 9, 
          :trending_rank => 0, 
          :local_rank => 6, 
          :city_rank => 10, 
          :worldwide_rank => 6, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 10, 
          :trending_rank => 2, 
          :local_rank => 6, 
          :city_rank => 10, 
          :worldwide_rank => 6, 
          :dayname => "sat"
        }, 
        {
          :geometry => {
            :type => "Polygon",
            :coordinates => [
              [ 37.7587890625, -122.4267578125 ],
              [ 37.759765625, -122.4267578125 ],
              [ 37.759765625, -122.42578125 ],
              [ 37.7587890625, -122.42578125 ],
              [ 37.7587890625, -122.4267578125 ]
            ]
          }, 
          :hour => 11, 
          :trending_rank => -1, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 12, 
          :trending_rank => 1, 
          :local_rank => 7, 
          :city_rank => 10, 
          :worldwide_rank => 7, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 13, 
          :trending_rank => 0, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 14, 
          :trending_rank => 0, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 15, 
          :trending_rank => 0, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 16, 
          :trending_rank => 0, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 17, 
          :trending_rank => 0, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 18, 
          :trending_rank => 0, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 19, 
          :trending_rank => 0, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 20, 
          :trending_rank => 0, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 21, 
          :trending_rank => -2, 
          :local_rank => 8, 
          :city_rank => 10, 
          :worldwide_rank => 8, 
          :dayname => "sat"
        }, 
        {
           :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 22, 
          :trending_rank => 0, 
          :local_rank => 5, 
          :city_rank => 10, 
          :worldwide_rank => 6, 
          :dayname => "sat"
        }, 
        {
          :geometry => {
             :type => "Polygon",
             :coordinates => [
               [ 37.7587890625, -122.4267578125 ],
               [ 37.759765625, -122.4267578125 ],
               [ 37.759765625, -122.42578125 ],
               [ 37.7587890625, -122.42578125 ],
               [ 37.7587890625, -122.4267578125 ]
             ]
           }, 
          :hour => 23, 
          :trending_rank => 1, 
          :local_rank => 5, 
          :city_rank => 10, 
          :worldwide_rank => 5, 
          :dayname => "sat"
        }
      ]
    end
  end
  
end
