require 'singleton'
require 'net/http'
require 'json'
require 'active_support/core_ext/hash/deep_merge'

require 'sparkpost_client/connection'
require 'sparkpost_client/rails/stored_template_delivery_agent'
require 'sparkpost_client/railtie' if defined?(Rails)

module SparkpostClient

  def self.configure(&b)
    @@conn = Connection.new
    @@conn.instance_eval(&b)
    raise 'Missing API key' unless @@conn.api_key
    @@conn
  end

  def self.connection
    @@conn
  end

  class APIError < StandardError

    def initialize(code, msg)
      @code, @msg = code, msg
      super(msg)
    end

  end

end
