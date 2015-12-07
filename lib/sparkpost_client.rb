require 'singleton'
require 'net/http'
require 'json'

require 'sparkpost_client/connection'
require 'sparkpost_client/rails/stored_template_delivery_agent'
require 'sparkpost_client/railtie'
require 'pry'

if defined?(Rails)
  binding.pry
	require 'sparkpost_client/rails/stored_template_delivery_agent'
	require 'sparkpost_client/rails/railtie'
end

module SparkpostClient

  def self.configure(&b)
    @conn = Connection.instance
    @conn.instance_eval(&b)
    @conn
  end

  class APIError < StandardError; end
  class AuthorizationError < StandardError; end

end
