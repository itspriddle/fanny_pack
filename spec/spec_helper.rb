require 'rspec'
require 'fakeweb'
require 'fanny_pack'

FakeWeb.allow_net_connect = false

def load_response(name)
  FakeWeb.clean_registry
  res = File.read File.expand_path("../fixtures/#{name}.txt", __FILE__)
  FakeWeb.register_uri :any, "https://netenberg.com/api", :body => res
end
