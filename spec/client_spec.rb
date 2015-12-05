require 'sparkpost/client'

describe Sparkpost::Client do


  describe '.configure' do

    it 'sets a FQDM connection host' do
      @client = Sparkpost::Client.configure { |c| c.host = "http://app.sparkpost.com" }
      expect(@client.host).to eq("http://app.sparkpost.com")
    end

    it 'sets a connection API key' do
      @client = Sparkpost::Client.configure { |c| c.api_key = "secret" }
      expect(@client.host).to eq("secret")
    end

  end

end
