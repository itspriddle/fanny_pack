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

  describe "#new" do
    it "sets the request @params hash" do
      @req.params.should respond_to :keys
    end
  end

  describe "#commit" do
    it "sets the @response hash", :pending => true do
      @req.commit.should respond_to :keys
    end

    it "sets @success if no error"
  end

end
