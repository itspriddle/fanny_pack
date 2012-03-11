require 'spec_helper'

describe FannyPack::FantasticoXMLBuilder do
  
  it "builds a soap envelope for request" do
    middleware = described_class.new(lambda{|env| env}, "test", {:param => "x"}, "34o8hti")
    env = {:body => nil, :request_headers => Faraday::Utils::Headers.new}
    result = middleware.call(env)
    xml = result[:body]
    xml.should include %{<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">\n  <env:Body>}
  end

end

describe FannyPack::FantasticoParser do

  it "returns an Array of Hashes if @action == :getIpListDetailed" do
    env = { :body => MultiXml.parse(load_fixture(:list_details)) }
    middleware = described_class.new(lambda{|env| env}, :getIpListDetailed)
    res = middleware.on_complete(env)
    res.should be_a Array
    res.should have(2).items
    %w[ipAddress addedOn isVPS status].each do |key|
      res.first.should have_key key
    end
  end

  it "returns a flat Array if @action is :getIpList" do
    env = { :body => MultiXml.parse(load_fixture(:list)) }
    middleware = described_class.new(lambda{|env| env}, :getIpList)
    res = middleware.on_complete(env)
    res.should be_a Array
    res.should have(2).items
    res[0].should == '127.0.0.1'
    res[1].should == '127.0.0.2'
  end

  it "returns a Hash if @action is not :getIpList or :getIpListDetailed" do
    env = { :body => MultiXml.parse(load_fixture(:add)) }
    middleware = described_class.new(lambda{|env| env}, :addIp)
    res = middleware.on_complete(env)
    res.should be_a Hash
  end

end
