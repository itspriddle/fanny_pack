require 'builder'
require 'crack'
require 'open-uri'
require 'net/https'

module FannyPack
  class Request
    attr_reader :params, :response

    VALID_ACTIONS = [
      :getIpList, :getIpListDetailed, :getIpDetails, :addIp,
      :editIp, :deactivateIp, :reactivateIp, :deleteIp
    ].freeze

    API_URL = "https://netenberg.com/api/server.php"

    def initialize
      @action   = :invalid
      @response = {}
      @params   = {}
    end

    def commit(action, params = {})
      unless VALID_ACTIONS.include? action.to_sym
        raise "Invalid action"
      end
      @action = action
      @params = params

      uri = URI.parse(API_URL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      res = http.post(uri.path, to_xml, 'Content-Type' => 'text/xml; charset=utf-8')
      parse(res.body)
    end

    def parse(data)
      hash = Crack::XML.parse(data)
      res  = find_key_in_hash(hash, 'item')
      case @action.to_sym
      when :editIp, :addIp, :deleteIp, :reactivateIp, :deactivateIp, :getIpDetails
        Hash[res.map { |r| [r['key'], r['value']] }]
      else
        res
      end
    end

    def to_xml
      xml = Builder::XmlMarkup.new :indent => 2
      xml.instruct!
      xml.tag! 'env:Envelope', 'xmlns:env' => 'http://schemas.xmlsoap.org/soap/envelope/' do
        xml.tag! 'env:Body' do
          xml.tag! @action do
            xml.tag! 'accountHASH', FannyPack.account_hash
            @params.each do |key, val|
              xml.tag! key, val
            end
          end
        end
      end
      xml.target!
    end

  private

    def find_key_in_hash(hash, index)
      hash.each do |key, val|
        if val.respond_to? :has_key?
          if val.has_key? index
            return val[index]
          else
            return find_key_in_hash val, index
          end
        else
          val
        end
      end
    end

  end
end

