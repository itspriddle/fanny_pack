require 'rspec'
require 'fakeweb'
require 'fanny_pack'

FakeWeb.allow_net_connect = false

def load_fixture(name, register = true)
  body = File.read File.expand_path("../fixtures/#{name}.txt", __FILE__)
  register_url(body) if register
  body
end

def register_url(body)
  FakeWeb.clean_registry
  FakeWeb.allow_net_connect = false
  FakeWeb.register_uri :any, FannyPack::Request::API_URL, :body => body
end

def requires_ip(&block)
  expect { block.call }.to raise_error(ArgumentError)
end
