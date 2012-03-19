module FannyPack
  autoload :Version, 'fanny_pack/version'
  autoload :Errors,  'fanny_pack/errors'
  autoload :Request, 'fanny_pack/request'
  autoload :IP,      'fanny_pack/ip'

  class << self
    # Your Fantastico account hash, used for API authentication
    #
    # @param [String] hash
    #   Your Fantastico account hash
    #
    # @return [String]
    attr_accessor :account_hash
  end

  # Returns true if FannyPack.account_hash is not nil or blank
  def self.account_hash?
    ! (account_hash.nil? || account_hash.to_s == "")
  end

end
