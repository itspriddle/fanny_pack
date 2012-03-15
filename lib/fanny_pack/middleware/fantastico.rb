module FannyPack
  class FantasticoXMLBuilder < Faraday::Middleware
    dependency 'builder'
      
    def initialize(app, *args)
      @action = args[0]
      @params = args[1]
      @hash = args[2]
      super(app)
    end

    def call(env)
      env[:body] = to_xml
      @app.call(env)
    end
      
    private
      
    # Builds the SOAP Envelope to be sent to Fantastico for this request
    #
    # @return [String]
    def to_xml
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.tag! 'env:Envelope', 'xmlns:env' => 'http://schemas.xmlsoap.org/soap/envelope/' do
        xml.tag! 'env:Body' do
          xml.tag! @action do
            xml.tag! 'accountHASH', @hash
            @params.each do |key, val|
              xml.tag! key, val
            end
          end
        end
      end
      xml.target!
    end
 
  end
  
  class FantasticoParser < Faraday::Response::Middleware
    
    def initialize(env, *args)
      @action = args[0]
      super(env)
    end

    def on_complete(env)
      env[:body] = parse(env[:body])
    end
      
  private
      
    # Parse the XML response from Fantastico
    #
    # Returns an Array or Hash depending on the API method called
    #
    # @param [String] data
    #   The XML response from Fantastico
    #
    # @return [Hash, Array]
    def parse(data)
      res = find_key_in_hash(data, 'item')
      if @action.to_sym == :getIpListDetailed
        res.map! do |r|
          Hash[r['item'].map { |i| [i['key'], i['value']] }]
        end
      elsif @action.to_sym == :getIpList
        res
      else
        Hash[res.map { |r| [r['key'], r['value']] }] if res.is_a? Array
      end
    end

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