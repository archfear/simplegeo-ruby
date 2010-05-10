require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'matchy'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'simplegeo'

class Test::Unit::TestCase
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
