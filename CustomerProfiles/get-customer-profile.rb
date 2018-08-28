require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_customer_profile(customerProfileId = '40036377')
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = GetCustomerProfileRequest.new
    request.customerProfileId = customerProfileId

    response = transaction.get_customer_profile(request)

    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully retrieved a customer with profile ID is #{request.customerProfileId} and whose customer ID is #{response.profile.merchantCustomerId}."
      response.profile.paymentProfiles.each do |paymentProfile|
        logger.info "  Payment Profile ID #{paymentProfile.customerPaymentProfileId}" 
        logger.info "  Payment Details:"
        if paymentProfile.billTo != nil
          logger.info "    Last Name: #{paymentProfile.billTo.lastName}"
          logger.info "    Address: #{paymentProfile.billTo.address}"    
        end
      end
      response.profile.shipToList.each do |ship|
        logger.info "  Shipping Address ID #{ship.customerAddressId}"
        logger.info "  Shipping Details:"
        logger.info "    First Name: #{ship.firstName}"
        logger.info "    Last Name: #{ship.lastName}"
        logger.info "    Address: #{ship.address}"
      end

      if response.subscriptionIds != nil && response.subscriptionIds.subscriptionId != nil
        logger.info "  List of subscriptions: "
        response.subscriptionIds.subscriptionId.each do |subscriptionId|
          logger.info "    #{subscriptionId}"
        end
      end

    else
      logger.error response.messages.messages[0].text
      raise "Failed to get customer profile information with ID #{request.customerProfileId}"
    end
    return response
  end
  
if __FILE__ == $0
  get_customer_profile()
end
  
