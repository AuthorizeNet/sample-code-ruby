require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_customer_payment_profile(customerProfileId = '40036377', customerPaymentProfileId = '36315992')
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = GetCustomerPaymentProfileRequest.new
    request.customerProfileId = customerProfileId
    request.customerPaymentProfileId = customerPaymentProfileId

    response = transaction.get_customer_payment_profile(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully retrieved a payment profile with profile ID #{request.customerPaymentProfileId} and whose customer ID is #{request.customerProfileId}."

      if response.paymentProfile.subscriptionIds != nil && response.paymentProfile.subscriptionIds.subscriptionId != nil
        logger.info "  List of subscriptions: "
        response.paymentProfile.subscriptionIds.subscriptionId.each do |subscriptionId|
          logger.info "#{subscriptionId}"
        end
      end

    else
      logger.error response.messages.messages[0].text
      raise "Failed to get payment profile information with ID #{request.customerPaymentProfileId}."
    end 
    return response
  end
  
if __FILE__ == $0
  get_customer_payment_profile()
end
