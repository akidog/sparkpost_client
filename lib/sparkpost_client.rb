require 'singleton'
require 'net/http'
require 'json'

require 'sparkpost_client/connection'
require 'pry'

module SparkpostClient

  def self.configure(&b)
    @conn = Connection.instance
    @conn.instance_eval(&b)
    @conn
  end

  class APIError < StandardError; end
  class AuthorizationError < StandardError; end

end
