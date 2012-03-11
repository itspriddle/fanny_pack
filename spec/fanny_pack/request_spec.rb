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

  describe "#commit" do
    it "raises exception unless action is valid" do
      expect { @req.commit :HammerTime }.to raise_error
    end
  end

end