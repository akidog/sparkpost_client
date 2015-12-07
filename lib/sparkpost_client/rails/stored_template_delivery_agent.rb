module SparkpostClient
  module Rails
    class StoredTemplateDeliveryAgent

      def deliver!(mail)
        raise 'Missing json' if mail.json_part.body.nil?
      end

    end
  end
end
