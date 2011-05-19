require 'builder'

module FannyPack
  class Request
    attr_reader :params, :response

    WSDL = "https://netenberg.com/api/"

    def self.run(cmd, params = {})
      command = case cmd.to_sym
      when :add
        if params[:type]
          params[:type] = FannyPack::IP::IP_TYPES[params[:type]]
        end
        :add_ip
      when :edit
        :edit_ip
      when :delete
        :delete_ip
      when :reactivate
        :reactivate_ip
      when :deactivate
        :deactivate_ip
      when :list
        if params[:details]
          params.delete :details
          :get_ip_list_detailed
        else
          :get_ip_list
        end
      when :details
        :get_ip_details
      else
        raise ArgumentError, "Invalid action #{cmd}"
      end
      params[:accountHASH] = FannyPack.account_hash
      self.new.commit params
    end

    def commit(action, params = {})
      @action = action
      @params = params
      @response = {}
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

