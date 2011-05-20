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

    it "has a value of 2 for :vps" do
      FannyPack::IP::IP_TYPES[:vps].should == 2
    end

    it { FannyPack::IP::IP_TYPES.should be_frozen }
  end

  describe "::add" do
    it "raises ArgumentError without IP" do
      expect {
        FannyPack::IP.add
      }.to raise_error(ArgumentError)
    end

    it "returns a Hash" do
      load_fixture :add
      ip = FannyPack::IP.add '127.0.0.1'
      ip.should be_a Hash
    end
  end

  describe "::edit" do
    it "raises ArgumentError without IP" do
      expect { FannyPack::IP.edit }.to raise_error(ArgumentError)
    end

    it "edits the IP" do
      load_fixture :edit
      ip = FannyPack::IP.edit '127.0.0.1', '127.0.0.2'
      ip.should be_a Hash
    end
  end

  describe "::list" do
    it "raises ArgumentError without type" do
      expect { FannyPack::IP.list }.to raise_error(ArgumentError)
    end

    it "raises error with invalid type" do
      expect { FannyPack::IP.list :Hollywood }.to raise_error(ArgumentError)
    end

    it "returns an array of IPs" do
      load_fixture :list
      ip = FannyPack::IP.list :all
      ip.should be_a Array
      ip.should have(2).items
      ip[0].should == '127.0.0.1'
      ip[1].should == '127.0.0.2'
    end

    it "returns an array of Hashes if details is true" do
      load_fixture :list_details
      ip = FannyPack::IP.list :all, true
      ip.should be_a Array
      ip.should have(2).items
      ip.each do |hash|
        hash.should be_a Hash
      end
    end
  end

  describe "::delete" do
    it "raises ArgumentError without IP" do
      expect { FannyPack::IP.delete }.to raise_error(ArgumentError)
    end

    it "deletes the IP" do
      load_fixture :delete
      ip = FannyPack::IP.delete '127.0.0.1'
      ip.should be_a Hash
      ip.should have_key 'deleted'
      ip.should have_key 'ip'
    end
  end

  %w[reactivate deactivate].each do |method|
    describe "::#{method}" do
      it "raises ArgumentError without IP" do
        expect { FannyPack::IP.send method }.to raise_error(ArgumentError)
      end

      it "#{method}s the IP" do
        load_fixture method
        ip = FannyPack::IP.send method, '127.0.0.1'
        ip.should be_a Hash
        %w[ipAddress addedOn isVPS status].each do |key|
          ip.should have_key key
        end
      end
    end
  end

  describe "::details" do
    it "raises ArgumentError without IP" do
      expect { FannyPack::IP.details }.to raise_error(ArgumentError)
    end

    it "returns a hash of IP details" do
      load_fixture :details
      ip = FannyPack::IP.details '127.0.0.1'
      ip.should be_a Hash
      %w[ipAddress addedOn isVPS status].each do |key|
        ip.should have_key key
      end
    end
  end
end
