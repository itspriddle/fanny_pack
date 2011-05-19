require 'spec_helper'

describe FannyPack do
  describe "::Version" do
    it "has a valid version" do
      FannyPack::Version.should match /\d+\.\d+\.\d+/
    end
  end

  describe "::account_hash" do
    it "gets the account_hash" do
      FannyPack.should respond_to :account_hash
    end

    it "sets the account_hash" do
      FannyPack.should respond_to :account_hash=
    end
  end

  describe "::account_hash?" do
    it "returns false if ::account_hash is nil or blank" do
      [nil, ""].each do |hash|
        FannyPack.account_hash = hash
        FannyPack.account_hash?.should be_false
      end
    end

    it "returns true if ::account_hash is set" do
      FannyPack.account_hash = "hash"
      FannyPack.account_hash?.should be_true
    end
  end
end
