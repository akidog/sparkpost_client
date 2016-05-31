module SparkpostClient
  class Connection

    SPARKPOST_ENDPOINT       = "https://api.sparkpost.com/api"
    SPARKPOST_ELITE_ENDPOINT = "https://%{domain}.msyscloud.com/api"

    attr_accessor :elite_domain, :api_version, :api_key, :debug, :use_sink_hole
    attr_reader :defaults

    def initialize(api_version='v1')
     @api_version, @defaults = api_version, {}
    end

    def endpoint
      endpoint = elite_domain ? SPARKPOST_ELITE_ENDPOINT % {domain: elite_domain} : SPARKPOST_ENDPOINT
      "#{endpoint}/#{api_version}"
    end

    %w(metrics message_events recipient_lists relay_webhooks sending_domains
    suppresion_list templates tracking_domains transmissions webhooks).each do |method|

      define_method method do |data, &blk|
        exec(method, data, &blk)
      end

      define_method "defaults_for_#{method}" do |data|
        @defaults[method] = parse_data!(data)
      end

    end

    private

    def exec(method, data, &blk)

      uri = URI.parse("#{endpoint}/#{method}")
      data = parse_data!(data)

      data.deep_merge!(@defaults[method]) unless @defaults[method].nil?

      req                   = Net::HTTP::Post.new(uri.path)
      req.body              = data.to_json
      req["Authorization"]  = api_key
      req["Content-Type"]   = "application/json"

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      if debug
        http.set_debug_output $stderr
      end

      res = http.start do |http|
        http.request(req)
      end

      #raise SparkpostClient::APIError.new(res.code, res.body) unless res.code =~ /^2[0-9]{2}$/

      block_given? ? blk.call(res.code, JSON.parse(res.body)) : res.body

    end

    def parse_data!(data)
      return data if data.is_a? Hash
      JSON.parse(data)
      rescue
        raise 'Bad data format. Data is not a valid json'
    end

  end
end
