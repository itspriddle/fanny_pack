require 'spec_helper'

describe FannyPack::Request do
  before :each do
    @req = FannyPack::Request.new
  end

  describe "::run" do
    it "raises ArgumentError on invalid command" do
      expect {
        FannyPack::Request.run :bad_command
      }.to raise_error(ArgumentError)
    end
  end

  describe "#to_xml" do
    it "builds a SOAP envelope" do
      @req.commit :list, :type => '1'
      xml = @req.to_xml
      xml.should include
        %{<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">\n  <env:Body>}
      xml.should include
        %{</env:Body>\n</env:Envelope>}
      xml.should match %r{<accountHASH>.*</accountHASH>}
    end
  end

  describe "#commit" do
    it "sets the @response hash", :pending => true do
      @req.commit.should respond_to :keys
    end

    it "sets @success if no error"
  end

end
