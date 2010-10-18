module SimpleGeo

  class Endpoint

    class << self
      def record(layer, id)
        endpoint_url "records/#{layer}/#{id}.json"
      end

      def records(layer, ids)
         ids = ids.join(',')  if ids.is_a? Array
         endpoint_url "records/#{layer}/#{ids}.json"
      end

      def add_records(layer)
        endpoint_url "records/#{layer}.json"
      end

      def history(layer, id)
        endpoint_url "records/#{layer}/#{id}/history.json"
      end

      def nearby_geohash(layer, geohash)
        endpoint_url "records/#{layer}/nearby/#{geohash}.json"
      end

      def nearby_coordinates(layer, lat, lon)
        endpoint_url "records/#{layer}/nearby/#{lat},#{lon}.json"
      end

      def nearby_address(lat, lon)
        endpoint_url "nearby/address/#{lat},#{lon}.json"
      end

      def density(lat, lon, day, hour=nil)
        if hour.nil?
          path = "density/#{day}/#{lat},#{lon}.json"
        else
          path = "density/#{day}/#{hour}/#{lat},#{lon}.json"
        end
        endpoint_url path
      end

      def layer(layer)
        endpoint_url "layer/#{layer}.json"
      end

      def contains(lat, lon)
        endpoint_url "contains/#{lat},#{lon}.json"
      end

      def overlaps(south, west, north, east)
        endpoint_url "overlaps/#{south},#{west},#{north},#{east}.json"
      end

      def boundary(id)
        endpoint_url "boundary/#{id}.json"
      end

      def locate(ip)
        endpoint_url "locate/#{ip}.json"
      end

      def endpoint_url(path)
        [REALM, API_VERSION, path].join('/')
      end
    end

  end

end
