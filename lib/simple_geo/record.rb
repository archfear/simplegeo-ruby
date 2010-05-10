module SimpleGeo
  class Record
    
    #TODO investigate whether to override id
    attr_accessor :layer, :id, :lat, :lon, :type, :created, :properties
  
    def initialize(options={})
      options = { 
        :created => Time.now, 
        :type => 'object', 
        :properties => {}
      }.merge(options)
    
      layer = options[:layer]
      id = options[:id]
      lat = options[:lat]
      lon = options[:lon]
      type = options[:type]
      created = options[:created]
      properties = options[:properties]
    end
    
    def to_hash
      {
        :type => 'Feature',
        :id => id,
        :created => created,
        :geometry => { 
          :type => 'Point',
          :coordinates => [ body[:lon], body[:lat] ]
        },
        :properties => properties.join({:type => type})
      }
    end
    
    def to_json
      self.to_hash.to_json
    end
    
  end
end
