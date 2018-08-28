require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def cancel_subscription(subscriptionId = '2790501',refId = '2238251168')
       transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
      #subscription = Subscription.new(config['api_login_id'], config['api_subscription_key'], :gateway => :sandbox)
      
        request = ARBCancelSubscriptionRequest.new
        request.refId = refId
        request.subscriptionId = subscriptionId
      
        response = transaction.cancel_subscription(request)
      
      if response != nil
        if response.messages.resultCode == MessageTypeEnum::Ok
          logger.info "Successfully cancelled a subscription."
          logger.info "  Response code: #{response.messages.messages[0].code}"
          logger.info "  Response message: #{response.messages.messages[0].text}"
        end
      
      else
        logger.error response.messages.messages[0].code
        logger.error response.messages.messages[0].text
        raise "Failed to cancel a subscription"
      end
      return response
  end

if __FILE__ == $0
  cancel_subscription()
end
