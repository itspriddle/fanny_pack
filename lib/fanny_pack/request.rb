require 'faraday'
require 'malcolm'

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
      
      conn = Faraday.new(:url => API_URL) do |c|
        c.request :soap
        c.response :soap, "item"
        c.adapter :net_http
      end
      
      request = conn.post do |r|
        r.body = format_params_for_fantastico
        r.headers = {'Content-Type' => 'text/xml; charset=utf-8'}
      end
      
      response = request.body
      
      @success = !(response.is_a?(Hash) && response.has_key?("faultcode"))
      
      response
    end

    # Returns true if a commit was successful
    #
    # @return [Boolean]
    def success?
      @success
    end
    
  private
  
  # Wraps each param value in array so XmlSimple interprets them as child elements rather than attributes 
  def format_params_for_fantastico
    params = @params.inject({}) do |result, (k, v)|
      result[k] = [v]
      result
    end
    {@action => {'accountHASH' => [FannyPack.account_hash]}.merge(params)}
  end

  end
end

