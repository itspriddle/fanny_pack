module FannyPack
  autoload :Version, 'fanny_pack/version'
  autoload :Errors,  'fanny_pack/errors'
  autoload :Request, 'fanny_pack/request'
  autoload :IP,      'fanny_pack/ip'

  class << self
    attr_accessor :account_hash
  end

  def self.account_hash?
    ! (account_hash.nil? || account_hash.to_s == "")
  end

end
