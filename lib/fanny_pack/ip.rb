module FannyPack
  class IP

    IP_TYPES = {
      :all    => 0,
      :normal => 1,
      :vps    => 2
    }.freeze

    def self.add(ip, ip_type = :normal)
      Request.run :add, :ip => ip, :type => :normal
    end

  end
end
