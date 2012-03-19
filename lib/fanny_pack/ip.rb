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
    # @param [String] ip
    #   The IP address to add
    #
    # @param [Symbol] ip_type
    #   The type of IP address (+:vps+ or +:normal+)
    #
    # @return [Hash]
    #
    # @example Add normal IP
    #   FannyPack::IP.add '127.0.0.1'
    #
    # @example Add vps IP
    #   FannyPack::IP.add '127.0.0.1', :vps
    def self.add(ip, ip_type = :normal)
      Request.new.commit :addIp, :ip => ip, :type => IP_TYPES[ip_type]
    end

    # Edit an IP address, replacing +ip+ with +new_ip+
    #
    # @param [String] ip
    #   The current IP address
    #
    # @param [String] new_ip
    #   The new IP address
    #
    # @return [Hash]
    #
    # @example
    #   FannyPack::IP.edit '127.0.0.1', '127.0.0.2'
    def self.edit(ip, new_ip)
      Request.new.commit :editIp, :ip => ip, :new_ip => new_ip
    end

    # Get a list of IP addresses on your Fantastico account
    #
    # The Fantastico API allows you to filter for only normal IPs, or only
    # vps IPs. Use +list_type+ +:all+ to get all IPs, +:normal+ to get only
    # normal IPs, or +:vps+ to get only vps IPs.
    #
    # @param [Symbol] list_type
    #   The list type, one of +:normal+, +:vps+, +:all+
    #
    # @param [Boolean] details
    #   Set to true to return details for each IP
    #
    # @raise [ArgumentError]
    #   Raised if list_type is invalid
    #
    # @return [Array]
    #   If +details+ is false, an array of IPs as +Strings+ is returned. If
    #   +details+ is true, an array of IPs as Hashes is returned.
    #
    # @example Show all IPs (simple list)
    #   FannyPack::IP.list :all
    #
    # @example Show all IPs (detailed list)
    #   FannyPack::IP.list :all, true
    #
    # @example Show normal IPs (simple list)
    #   FannyPack::IP.list :normal
    #
    # @example Show normal IPs (detailed list)
    #   FannyPack::IP.list :normal, true
    #
    # @example Show vps IPs (simple list)
    #   FannyPack::IP.list :vps
    #
    # @example Show normal IPs (detailed list)
    #   FannyPack::IP.list :vps, true
    def self.list(list_type, details = false)
      cmd = details ? :getIpListDetailed : :getIpList
      unless IP_TYPES.keys.include? list_type
        raise ArgumentError, "Invalid list type"
      end
      response = Request.new.commit cmd, :listType => IP_TYPES[list_type]
      if details
        items = response[:item].map{|i| i[:item] }
        items.map do |item|
          item.inject({}) do |result, pair|
            result[pair[:key]] = pair[:value]
            result
          end
        end
      else
        response[:item]
      end
    end

    # Delete an IP address from your Fantastico Account
    #
    # @param [String] ip
    #   The IP address to delete
    #
    # @return [Hash]
    #
    # @example
    #   FannyPack::IP.delete '127.0.0.1'
    def self.delete(ip)
      response = Request.new.commit :deleteIp, :ip => ip
      response[:item].inject({}) do |result, pair|
        result[pair[:key]] = pair[:value]
        result
      end
    end

    # Reactivate a deactivated IP address
    #
    # @param [String] ip
    #   The IP address to reactivate
    #
    # @return [Hash]
    #
    # @example
    #   FannyPack::IP.reactivate '127.0.0.1'
    def self.reactivate(ip)
      response = Request.new.commit :reactivateIp, :ip => ip
      response[:item].inject({}) do |result, pair|
        result[pair[:key]] = pair[:value]
        result
      end
    end

    # Deactivate an IP address
    #
    # @param [String] ip
    #   The IP address to deactivate
    #
    # @return [Hash]
    #
    # @example
    #   FannyPack::IP.deactivate '127.0.0.1'
    def self.deactivate(ip)
      response = Request.new.commit :deactivateIp, :ip => ip
      response[:item].inject({}) do |result, pair|
        result[pair[:key]] = pair[:value]
        result
      end
    end

    # Get details for an IP address
    #
    # @param [String] ip
    #    The IP address to look up
    #
    # @return [Hash]
    #
    # @example
    #   FannyPack::IP.details '127.0.0.1'
    def self.details(ip)
      response = Request.new.commit :getIpDetails, :ip => ip
      response[:item].inject({}) do |result, pair|
        result[pair[:key]] = pair[:value]
        result
      end
    end
  end
end
