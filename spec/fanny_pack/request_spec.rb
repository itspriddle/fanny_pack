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
        @req.instance_variable_get("@#{test}").should respond_to :keys
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
    before :each do
      @req.commit :getIpList, :type => 1
    end

    it "raises exception unless action is valid" do
      expect { @req.commit :HammerTime }.to raise_error
    end

    it "sets the request @params hash" do
      @req.params.should respond_to :keys
    end

    it "sets the @response hash", :pending => true do
      @req.commit.should respond_to :keys
    end

    it "sets @success if no error"
  end

end
