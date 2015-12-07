require 'sparkpost_client'

describe SparkpostClient do

  let!(:client) { subject::configure { |c| c.api_key = 'secret' } }

  it 'raises an error is API key is missing' do
    expect {
      subject::configure { }
    }.to raise_error("Missing API key")
  end

  describe '.configure' do
    context 'api version' do

      it 'defaults do v1' do
        expect(client.api_version).to eq("v1")
      end

      it 'sets a version' do
        client = SparkpostClient::configure { |c| c.api_key = 'secret', c.api_version = "v2" }
        expect(client.api_version).to eq("v2")
      end
    end

    it 'sets an API key' do
      expect(client.api_key).to eq("secret")
    end

    it 'sets a custom domain for elite accounts' do
      client = SparkpostClient::configure { |c| c.api_key = 'secret'; c.elite_domain = "mydomain" }
      expect(client.elite_domain).to eq("mydomain")
    end

    %w(metrics message_events recipient_lists relay_webhooks sending_domains
    suppresion_list templates tracking_domains transmissions webhooks).each do |method|
      it "sets global default data for #{method}" do
        client = SparkpostClient::configure do |c|
          c.api_key = 'secret',
          c.send("defaults_for_#{method}", {"foo" => "bar"})
        end

        expect(client.defaults[method]).to eq({"foo" => "bar"})

      end
    end

  end

  describe '.connection' do

    it 'returns the current connection' do
      expect(subject.connection).to eq(client)
    end


  end

end
