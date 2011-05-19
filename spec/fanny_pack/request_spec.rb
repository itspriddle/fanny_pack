require 'spec_helper'

describe FannyPack::Request do

  describe "::VALID_ACTIONS" do
    it { FannyPack::Request::VALID_ACTIONS.should be_frozen }
  end

  before :each do
    @req = FannyPack::Request.new
  end

  describe "::new" do
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

    it "returns #success?" do
      load_fixture :list
      res = @req.commit :getIpList, :type => 1
      res.should == @req.success?
    end
  end

  describe "#parse" do
    before :each do
      @res = @req.parse load_fixture :add
    end

    it "parses XML to set the @response hash" do
      @res.should respond_to :keys
    end

    it "sets @success if no error"
  end

  describe "#success?" do
    it "returns true or false based on @success"
  end

end
