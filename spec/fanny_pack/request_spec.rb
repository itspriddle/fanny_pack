require 'spec_helper'

describe FannyPack::Request do

  describe "::VALID_ACTIONS" do
    it { FannyPack::Request::VALID_ACTIONS.should be_frozen }
  end

  before :each do
    @req = FannyPack::Request.new
  end

  describe "#initialize" do
    %w[response params].each do |test|
      it "sets @#{test} to a hash" do
        @req.instance_variable_get("@#{test}").should be_a Hash
      end
    end
  end

  %w[response params].each do |test|
    describe "##{test}" do
      it "returns @#{test}" do
        @req.instance_variable_get("@#{test}").should == @req.send(test)
      end
    end
  end

  describe "#to_xml" do
    it "builds a SOAP envelope" do
      xml = @req.to_xml
      xml.should include
        %{<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">\n  <env:Body>}
      xml.should include
        %{</env:Body>\n</env:Envelope>}
      xml.should match %r{<accountHASH>.*</accountHASH>}
    end
  end

  describe "#commit" do
    it "raises exception unless action is valid" do
      expect { @req.commit :HammerTime }.to raise_error
    end
  end

  describe "#parse" do
    before :each do
      @req.instance_variable_set("@action", :addIp)
      @res = @req.parse load_fixture :add
    end

    it "parses XML to set the @response hash" do
      @res.should be_a Hash
    end

    it "sets @success" do
      @req.instance_variable_get("@success").should_not be_nil
    end
  end

  describe "#success?" do
    it "returns true or false based on @success" do
      @req.instance_variable_set("@action", :addIp)
      @req.parse load_fixture :add
      @req.instance_variable_get("@success").should_not be_nil
    end
  end

end
