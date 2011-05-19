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
    end

  end
end
