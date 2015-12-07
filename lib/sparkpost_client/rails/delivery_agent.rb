module SparkpostClient
  module Rails
    class DeliveryAgent

      def deliver!(mail)
        #@client = SparkpostClient::Connection.instance
				#{
					#:content => {
            #:from => {
              #:name   => mail[:to].display_names.first,
              #:email  => mail.from.first
            #},
            #:subject  => mail.subject,
            #:reply_to => mail.reply_to.first
          #}
				#}
      end

    end
  end
end
