require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_transaction_Details()
      transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
      
      transId = "60032208160"
      request = GetTransactionDetailsRequest.new
      request.transId = transId
      
      #standard api call to retrieve response
      response = transaction.get_transaction_details(request)
      
      if response.messages.resultCode == MessageTypeEnum::Ok
        logger.info "Get Transaction Details Successful " 
        logger.info "Transaction Id:   #{response.transaction.transId}"
        logger.info "Transaction Type:   #{response.transaction.transactionType}"
        logger.info "Transaction Status:   #{response.transaction.transactionStatus}"
        logger.info "Description: #{response.transaction.order.description}"
        logger.info "Auth Amount:  %.2f" % response.transaction.authAmount
        logger.info "Settle Amount:  %.2f" % response.transaction.settleAmount
      else
        logger.error response.messages.messages[0].code
        logger.error response.messages.messages[0].text
        raise "Failed to get transaction Details."
      end
    
    return response
  end
  
  
if __FILE__ == $0
  get_transaction_Details()
end