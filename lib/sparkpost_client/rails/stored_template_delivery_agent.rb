module SparkpostClient
  module Rails
    class StoredTemplateDeliveryAgent

       def initialize(options = {})
         @settings = options
       end

      def deliver!(mail)
        json = parse_json!(mail.body.to_s)

        recipients = mail.to.each_with_index.map do |email, i|
          {
            "address" => email
            #"name" => mail[:to].display_names[i]
          }
        end

        recipients = { "recipients" => recipients }

        content = {
          "from" => {
            "name" => mail[:from].display_names.first,
            "email" => mail.from.first
          },
          "subject" => mail.subject
          #"reply_to" => mail.reply_to.try(:first)
        }

        json.merge!(recipients)
        json.deep_merge!(content)

        @client = SparkpostClient::connection
        @client.transmissions(json)
      end

      def parse_json!(data)
        JSON.parse(data)
        rescue
          raise 'Missing or invalid json'
      end

    end
  end
end
