module SimpleGeo
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      # Return a new hash with all keys converted to symbols.
      def symbolize_keys
        inject({}) do |options, (key, value)|
          options[(key.to_sym rescue key) || key] = value
          options
        end
      end
      
      # Destructively convert all keys to symbols.
      def symbolize_keys!
        self.replace(self.symbolize_keys)
      end
    end
  end
end

unless Hash.method_defined? :symbolize_keys
  Hash.send(:include, SimpleGeo::CoreExtensions::Hash)
end
