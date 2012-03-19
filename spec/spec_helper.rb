require 'rspec'
require 'vcr'
require 'vcr_patch'
require 'fanny_pack'
require 'xmlsimple'

FannyPack.account_hash = "test"

def requires_ip(&block)
  expect { block.call }.to raise_error(ArgumentError)
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :fakeweb
  c.default_cassette_options = {:record => :none, :match_requests_on => [:xml_body_without_order]}
  c.register_request_matcher :xml_body_without_order do |request1, request2|
    XmlSimple.xml_in(request1.body) == XmlSimple.xml_in(request2.body)
  end
end
