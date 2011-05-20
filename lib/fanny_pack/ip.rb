module FannyPack
  class IP

    IP_TYPES = {
      :all    => 0,
      :normal => 1,
      :vps    => 2
    }.freeze

    def self.add(ip, ip_type = :normal)
      Request.new.commit :addIp, :ip => ip, :type => IP_TYPES[ip_type]
    end

    def self.edit(ip, new_ip)
      Request.new.commit :editIp, :ip => ip, :new_ip => new_ip
    end

    def self.list(list_type, details = false)
      cmd = details ? :getIpListDetailed : :getIpList
      unless IP_TYPES.keys.include? list_type
        raise ArgumentError, "Invalid list type"
      end
      Request.new.commit cmd, :listType => list_type
    end
  end
end
