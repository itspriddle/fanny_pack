module VCR
	module Errors
    class UnhandledHTTPRequestError

    private

      def request_description
        "#{request.method.to_s.upcase} #{request.uri} \n #{request.body}"
      end
      
    end
  end
end