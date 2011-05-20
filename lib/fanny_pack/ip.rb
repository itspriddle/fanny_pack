module FannyPack
  # FannyPack::IP is the main class for managing IPs via the Fantastico API.
  class IP

    # The Fantastico API tags your IPs as "normal" or "vps".
    IP_TYPES = {
      :all    => 0,
      :normal => 1,
      :vps    => 2
    }.freeze

    # Add an IP address to your Fantastico account.
    #
    # Returns a Hash containing the new IP info on success
    # Returns a Hash containing an error code and message on error
    #
    # ==== Options
    #
    # * +ip+ - The cPanel IP address to add
    # * +ip_type* - The type of IP address (:vps or :normal)
    #
    # ==== Examples
    #
    #   # Add normal IP
    #   FannyPack::IP.add '127.0.0.1'
    #
    #   # Add vps IP
    #   FannyPack::IP.add '127.0.0.1', :vps
    def self.add(ip, ip_type = :normal)
      Request.new.commit :addIp, :ip => ip, :type => IP_TYPES[ip_type]
    end

    # Edit an IP address, replacing +ip+ with +new_ip+
    #
    # Returns a Hash containing the new IP info on success
    # Returns a Hash containing an error code and message on error
    #
    # ==== Options
    #
    # * +ip+ - The current IP address
    # * +new_ip+ - The new IP address
    #
    # ==== Example
    #
    #   FannyPack::IP.edit '127.0.0.1', '127.0.0.2'
    def self.edit(ip, new_ip)
      Request.new.commit :editIp, :ip => ip, :new_ip => new_ip
    end

    # Get a list of IP addresses on your Fantastico account
    #
    # The Fantastico API allows you to filter for only normal IPs, or only
    # vps IPs. Use +list_type+ :all to get all IPs, :normal to get only normal
    # IPs, or :vps to get only vps IPs.
    #
    # Raises ArgumentError if list_type is invalid
    #
    # If +details+ is false:
    # Returns an Array containing IP addresses
    #
    # If +details+ is true:
    # Returns an Array of Hashes containing info for each IP
    #
    # Returns a Hash containing an error code and message on error
    #
    # ==== Options
    #
    # * +list_type+ - The list type, one of :normal, :vps, :all
    # * +details+ - Set to true to return details for each IP
    #
    # ==== Examples
    #
    #   # Show all IPs (simple list)
    #   FannyPack::IP.list :all
    #
    #   # Show all IPs (detailed list)
    #   FannyPack::IP.list :all, true
    #
    #   # Show normal IPs (simple list)
    #   FannyPack::IP.list :normal
    #
    #   # Show normal IPs (detailed list)
    #   FannyPack::IP.list :normal, true
    #
    #   # Show vps IPs (simple list)
    #   FannyPack::IP.list :vps
    #
    #   # Show normal IPs (detailed list)
    #   FannyPack::IP.list :vps, true
    def self.list(list_type, details = false)
      cmd = details ? :getIpListDetailed : :getIpList
      unless IP_TYPES.keys.include? list_type
        raise ArgumentError, "Invalid list type"
      end
      Request.new.commit cmd, :listType => IP_TYPES[list_type]
    end

    # Delete an IP address from your Fantastico Account
    #
    # Returns a Hash containing the IP info
    # Returns a Hash containing an error code and message on error
    #
    # ==== Options
    #
    # * +ip+ - The IP address to delete
    #
    # ==== Example
    #
    #   FannyPack::IP.delete '127.0.0.1'
    def self.delete(ip)
      Request.new.commit :deleteIp, :ip => ip
    end

    # Reactivate a deactivated IP address
    #
    # Returns a Hash containing the IP info
    # Returns a Hash containing an error code and message on error
    #
    # ==== Options
    #
    # * +ip+ - The IP address to reactivate
    #
    # ==== Example
    #
    #   FannyPack::IP.reactivate '127.0.0.1'
    def self.reactivate(ip)
      Request.new.commit :reactivateIp, :ip => ip
    end

    # Deactivate an IP address
    #
    # Returns a Hash containing the IP info
    # Returns a Hash containing an error code and message on error
    #
    # ==== Options
    #
    # * +ip+ - The IP address to deactivate
    #
    # ==== Example
    #
    #   FannyPack::IP.deactivate '127.0.0.1'
    def self.deactivate(ip)
      Request.new.commit :deactivateIp, :ip => ip
    end

    # Get details for an IP address
    #
    # Returns a Hash containing the IP info
    # Returns a Hash containing an error code and message on error
    #
    # ==== Options
    #
    # * +ip+ - The IP address to lookup
    #
    # ==== Example
    #
    #   FannyPack::IP.details '127.0.0.1'
    def self.details(ip)
      Request.new.commit :getIpDetails, :ip => ip
    end
  end
end
