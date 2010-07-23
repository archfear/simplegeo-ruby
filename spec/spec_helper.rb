$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'simple_geo'
require 'spec'
require 'spec/autorun'
require 'fakeweb'

Spec::Runner.configure do |config|

  # don't allow any external connections
  FakeWeb.allow_net_connect = false

  config.before(:each) do
    FakeWeb.clean_registry
  end
end

def fixture_file(filename)
  file_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/" + filename)
  File.read(file_path)
end

def stub_request(method, url, options={})
  if options[:fixture_file]
    options[:body] = fixture_file(options.delete(:fixture_file))
  end
  FakeWeb.register_uri(method, url, options)
end
