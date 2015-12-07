module SparkpostClient
  class Connection

    SPARKPOST_ENDPOINT       = "https://api.sparkpost.com/api"
    SPARKPOST_ELITE_ENDPOINT = "https://%{domain}.msyscloud.com/api"

    attr_accessor :elite_domain, :api_version, :api_key

    include Singleton

    def endpoint
      endpoint = elite_domain ? SPARKPOST_ELITE_ENDPOINT % {domain: elite_domain} : SPARKPOST_ENDPOINT
      "#{endpoint}/#{api_version}"
    end

    def exec(method, data, &blk)
      uri = URI.parse("#{endpoint}/#{method}")

      req                   = Net::HTTP::Post.new(uri.path)
      req.body              = convert_to_json(data.deep_merge!(@defaults[method]))
      req["Authorization"]  = api_key
      req["Content-Type"]   = "application/json"


      #begin
        res= Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.request(req)
        end
      #rescue Net::HTTPUnprocessableEntity
        #raise SparkPost::APIError
      #rescue Net::HTTPUnauthorized
        #raise Sparkpost::AuthorizationError
      #end
      blk.call(res.code, JSON.parse(res.body))

    end

    %w(metrics message_events recipient_lists relay_webhooks sending_domains
    suppresion_list templates tracking_domains transmissions webhooks).each do |method|

      define_method method do |data, &blk|
        exec(method, data, &blk)
      end

      define_method "defaults_for_#{method}" do |data|
        @defaults[method] = convert_to_json(data)
      end


    end

    private

    def convert_to_json(data)
      return data if data.is_a? JSON
      if data.is_a? Hash
        data.to_json
      else
        raise 'Bad data format. Data is neither a json or a hash'
      end
    end

  end
end
