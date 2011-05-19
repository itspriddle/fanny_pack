require 'builder'
require 'crack'

module FannyPack
  class Request
    attr_reader :params, :response

    VALID_ACTIONS = [
      :getIpList, :getIpListDetailed, :getIpDetails, :addIp,
      :editIp, :deactivateIp, :reactivateIp, :deleteIp
    ].freeze

    API_URL = "https://netenberg.com/api/"

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
      success?
    end

    def success?

    end

    def parse(data)
      xml = Crack::XML.parse(data)
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

  end
end

