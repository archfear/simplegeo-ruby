module SimpleGeo
  class Record
    attr_accessor :layer, :id, :lat, :lon, :type, :created, :properties
  
    def initialize(options={})
      options = { 
        :created => Time.now,
        :type => 'object',
        :properties => {}
      }.merge(options)

      @id = options[:id]
      @layer = options[:layer]
      @type = options[:type]
      @lat = options[:lat]
      @lon = options[:lon]
      @created = options[:created]
      @properties = options[:properties]
    end
    
    def to_hash
      {
        :type => 'Feature',
        :id => id,
        :created => created.to_i,
        :geometry => { 
          :type => 'Point',
          :coordinates => [ lon, lat ]
        },
        :properties => properties.merge({
          :type => type,
          :layer => layer
        })
      }
    end
    
    def to_json
      self.to_hash.to_json
    end
    
    def self.parse_json(json_hash)
      Record.new(
        :id => json_hash['id'],
        :layer => json_hash['properties'].delete('layer'),
        :type => json_hash['properties'].delete('type'),
        :lat => json_hash['geometry']['coordinates'][1],
        :lon => json_hash['geometry']['coordinates'][0],
        :created => Time.at(json_hash['created']),
        :properties => json_hash['properties'].symbolize_keys
      )
    end
  end
end
