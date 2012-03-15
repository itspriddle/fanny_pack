require 'rspec'
require 'fakeweb'
require 'vcr'
require 'fanny_pack'

def load_fixture(name)
  File.read File.expand_path("../fixtures/#{name}.txt", __FILE__)
end

def requires_ip(&block)
  expect { block.call }.to raise_error(ArgumentError)
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :fakeweb
  c.default_cassette_options = {:record => :none}
end
