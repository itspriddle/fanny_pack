require 'builder'
require 'crack/xml'
require 'open-uri'
require 'net/https'

module FannyPack
  # FannyPack::Request handles forming the XML request to be sent to the
  # Fantastico API, and parsing the response.
  class Request
    # Parameters for the API request
    #
    # @return [Hash]
    attr_reader :params

    # The parsed API response
    #
    # @return [Hash]
    attr_reader :response

    # The Fantastico API supports these methods
    VALID_ACTIONS = [
      :getIpList, :getIpListDetailed, :getIpDetails, :addIp,
      :editIp, :deactivateIp, :reactivateIp, :deleteIp
    ].freeze

    # The URL for the Fantastico API
    API_URL = "https://netenberg.com/api/server.php"

    def initialize
      @action   = :invalid
      @response = {}
      @params   = {}
    end

    # Send this request to the Fantastico API
    #
    # Returns a Hash or Array, depending on the response from Fantastico
    #
    # @param [Symbol] action
    #   The action to perform, one of +VALID_ACTIONS+
    #
    # @param [Hash]
    #   Parameters for the API method
    #
    # @return [Hash, Array]
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

    # Parse the XML response from Fantastico
    #
    # Returns an Array or Hash depending on the API method called
    #
    # @param [String] data
    #   The XML response from Fantastico
    #
    # @return [Hash, Array]
    def parse(data)
      res = find_key_in_hash(Crack::XML.parse(data), 'item')
      if @action.to_sym == :getIpListDetailed
        res.map! do |r|
          Hash[r['item'].map { |i| [i['key'], i['value']] }]
        end
      elsif @action.to_sym == :getIpList
        res
      else
        res = Hash[res.map { |r| [r['key'], r['value']] }] if res.is_a? Array
      end

      @success = ! res.has_key?("faultcode") if res.respond_to?(:has_key?)
      res
    end

    # Returns true if a commit was successful
    #
    # @return [Boolean]
    def success?
      @success
    end

    # Builds the SOAP Envelope to be sent to Fantastico for this request
    #
    # @return [String]
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

    # Finds +index+ in +hash+ by searching recursively
    #
    # @param [Hash] hash
    #   The hash to search
    #
    # @param index
    #   The hash key to look for
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

