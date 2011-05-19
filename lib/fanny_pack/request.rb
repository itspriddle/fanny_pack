require 'builder'

module FannyPack
  class Request
    attr_reader :params, :response

    VALID_ACTIONS = [
      :getIpList, :getIpListDetailed, :getIpDetails, :addIp,
      :editIp, :deactivateIp, :reactivateIp, :deleteIp
    ].freeze

    URL = "https://netenberg.com/api/"

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

