describe SparkpostClient::Connection do

  it 'builds an endpoint' do
    conn = SparkpostClient.configure { |c| c.api_key = 'secret'; }
    expect(conn.endpoint).to eq("https://api.sparkpost.com/api/v1")
  end

  it 'builds a elite endpoint' do
    conn = SparkpostClient.configure { |c| c.api_key = 'secret'; c.elite_domain = "mydomain" }
    expect(conn.endpoint).to eq("https://mydomain.msyscloud.com/api/v1")
  end

  describe '.transmissions' do

    let!(:client) do
      SparkpostClient::configure do |c|
        c.debug = true
        c.api_key = '7b82027272dc656a3784bd13fba75d3310547e47'
        c.defaults_for_transmissions ({
          options: {
            transactional: true,
            open_tracking: true,
            sandbox: true
          }
        })
      end
    end

    it 'raises an error if data is not a Hash or cannot be parsed as JSON' do
      expect {
        client.transmissions("{ 'foo': 'bar' }")
      }.to raise_error('Bad data format. Data is not a valid json')
    end

    describe "whatever" do

      let(:data) do
        {
          content: {
            template_id: "users-signup-0d0e22137353375f4cb25138105a9ba4",
          },
          substitution_data: {
              name: "felipe",
              aqui: "a"
          },
          recipients: [{
            address: "felipe@akidog.com.br"
          }]
        }
      end

      it 'returns response to a block control' do
        client.transmissions(data) do |code, response|
          expect(response).to eq('')
        end
      end

      it 'returns the response' do
        response = client.transmissions(data)
        expect(response).to eq('')
      end

    end
  end

end
