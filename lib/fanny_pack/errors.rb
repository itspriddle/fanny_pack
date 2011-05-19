module FannyPack
  module Errors
    FAULT_CODES = {
      1302 => "You have specified an invalid hash.",
      1401 => "You are trying to access the API from a server whose IP Address is not authorized.",
      1603 => "You are not allowed to add any more IP Addresses because you have reached your IP Address quota.",
      1703 => "The IP Address that you have specified is not a valid VPS IP Address.",
      1704 => "The new IP Address that you have specified is not a valid cPanel IP Address.",
      1705 => "The new IP Address that you have specified is not a valid cPanel IP Address.",
      1801 => "The IP Address that you have specified does not exist.",
      1804 => "The IP Address that you have specified already exists."
    }.freeze

    class AuthRequired < StandardError
      def initialize(msg = nil)
        super "Must set FannyPack.account_hash"
      end
    end
  end
end
