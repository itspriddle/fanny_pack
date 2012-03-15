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
    use_vcr_cassette "ip/add"
      
    it "raises ArgumentError without IP" do
      requires_ip { FannyPack::IP.add }
    end

    it "returns a Hash" do
      ip = FannyPack::IP.add '127.0.0.1'
      ip.should be_a Hash
    end
  end

  describe "::edit" do
    use_vcr_cassette "ip/edit"
    it "raises ArgumentError without IP" do
      requires_ip { FannyPack::IP.edit }
    end

    it "edits the IP" do
      ip = FannyPack::IP.edit '127.0.0.1', '127.0.0.2'
      ip.should be_a Hash
    end
  end

  describe "::list" do
    use_vcr_cassette "ip/list"
    
    it "raises ArgumentError without type" do
      requires_ip { FannyPack::IP.list }
    end

    it "raises error with invalid type" do
      expect { FannyPack::IP.list :Hollywood }.to raise_error(ArgumentError)
    end

    it "returns an array of IPs" do
      ip = FannyPack::IP.list :all
      ip.should be_a Array
      ip.should have(2).items
      ip[0].should == '127.0.0.1'
      ip[1].should == '127.0.0.2'
    end

    context "if details is true" do

      use_vcr_cassette "ip/list_details"
      
      it "returns an array of Hashes if details is true" do
        ip = FannyPack::IP.list :all, true
        ip.should be_a Array
        ip.should have(2).items
        ip.each do |hash|
          hash.should be_a Hash
          %w[ipAddress addedOn isVPS status].each do |key|
            hash.should have_key key
          end
        end
      end
      
    end
  end

  describe "::delete" do
    use_vcr_cassette "ip/delete"
    
    it "raises ArgumentError without IP" do
      requires_ip { FannyPack::IP.delete }
    end

    it "deletes the IP" do
      ip = FannyPack::IP.delete '127.0.0.1'
      ip.should be_a Hash
      ip.should have_key 'deleted'
      ip.should have_key 'ip'
    end
  end

  %w[reactivate deactivate].each do |method|
    describe "::#{method}" do
      use_vcr_cassette "ip/#{method}"
      it "raises ArgumentError without IP" do
        requires_ip { FannyPack::IP.send(method) }
      end

      it "#{method}s the IP" do
        ip = FannyPack::IP.send method, '127.0.0.1'
        ip.should be_a Hash
        %w[ipAddress addedOn isVPS status].each do |key|
          ip.should have_key key
        end
      end
    end
  end

  describe "::details" do
    use_vcr_cassette "ip/details"
    
    it "raises ArgumentError without IP" do
      requires_ip { FannyPack::IP.details }
    end

    it "returns a hash of IP details" do
      ip = FannyPack::IP.details '127.0.0.1'
      ip.should be_a Hash
      %w[ipAddress addedOn isVPS status].each do |key|
        ip.should have_key key
      end
    end
  end
end
