require 'spec_helper'

describe FannyPack::IP do
  describe "::IP_TYPES" do
    it { FannyPack::IP::IP_TYPES.should be_a Hash }

    it "has a value of 0 for :all" do
      FannyPack::IP::IP_TYPES[:all].should == 0
    end

    it "has a value of 1 for :normal" do
      FannyPack::IP::IP_TYPES[:normal].should == 1
    end

    it "has a key of 2 for :vps" do
      FannyPack::IP::IP_TYPES[:vps].should == 2
    end

    it { FannyPack::IP::IP_TYPES.should be_frozen }
  end

  describe "::add" do
    it "raises ArgumentError without IP" do
      expect {
        FannyPack::IP.add
      }.to raise_error(ArgumentError)

      expect {
        FannyPack::IP.add '127.0.0.1'
      }.to_not raise_error(ArgumentError)
    end

    it "returns a Hash", :pending => true do
      load_response :add
      ip = FannyPack::IP.add '127.0.0.1'
      ip.should be_a Hash
    end
  end
end
