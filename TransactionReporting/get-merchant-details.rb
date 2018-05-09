require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_merchant_details()
      transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
      
      request = GetMerchantDetailsRequest.new
      
      #standard api call to retrieve response
      response = transaction.get_merchant_details(request)
      
      if response.messages.resultCode == MessageTypeEnum::Ok
        logger.info "Get Merchant Details Successful " 
        logger.info "Gateway Id:   #{response.gatewayId}"
        logger.info "Merchant Name:   #{response.merchantName}"
        response.processors.processor.each do |processor|
          logger.info "Processor Name: #{processor.name}"
        end
        response.marketTypes.each do |marketType|
          logger.info "MarketType: #{marketType}"
        end
        response.productCodes.each do |productCode|
          logger.info "Product Code: #{productCode}"
        end
        response.paymentMethods.each do |paymentMethod|
          logger.info "Payment Method: #{paymentMethod}"
        end
        response.currencies.each do |currency|
          logger.info "Currency: #{currency}"
        end

      else
        logger.error response.messages.messages[0].code
        logger.error response.messages.messages[0].text
        raise "Failed to get transaction Details."
      end
    
    return response
  end
  
  
if __FILE__ == $0
  get_merchant_details()
end