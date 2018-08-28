require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_subscription(subscriptionId = '2930242')
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    request = ARBGetSubscriptionRequest.new
  
    request.refId = 'Sample'
    request.subscriptionId = subscriptionId
     
    response = transaction.arb_get_subscription_request(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully got subscription details."
      logger.info "  Response code: #{response.messages.messages[0].code}"
      logger.info "  Response message: #{response.messages.messages[0].text}"
      logger.info "  Subscription name: #{response.subscription.name}"
      logger.info "  Payment schedule start date: #{response.subscription.paymentSchedule.startDate}"
      logger.info "  Payment schedule Total Occurrences: #{response.subscription.paymentSchedule.totalOccurrences}"
      logger.info "  Subscription amount: %.2f " % [response.subscription.amount]
      logger.info "  Subscription profile description: #{response.subscription.profile.description}"
      logger.info "  First Name in Billing Address: #{response.subscription.profile.paymentProfile.billTo.firstName}"
     
    else
      logger.error response.messages.messages[0].code
      logger.error response.messages.messages[0].text
      raise "Failed to get subscription details."
    end
    
    return response
  end
  
if __FILE__ == $0
  get_subscription()
end
