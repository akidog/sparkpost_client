module SparkpostClient
		class Railtie < Rails::Railtie
			initializer "sparkpost_client.add_delivery_method" do
				ActiveSupport.on_load :action_mailer do
					ActionMailer::Base.add_delivery_method :sparkpost, SparkpostClient::Rails::DeliveryAgent, return_response: true
					ActionMailer::Base.add_delivery_method :sparkpost_stored_template, SparkpostClient::Rails::StoredTemplateDeliveryAgent, return_response: true
				end
			end
		end
end
