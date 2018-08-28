require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'
  
  include AuthorizeNet::API
  
  def credit()
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    request = CreateTransactionRequest.new
    
    payPalType = PayPalType.new()
    payPalType.successUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    payPalType.cancelUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    
    #standard api call to retrieve response
    paymentType = PaymentType.new()
    paymentType.payPal = payPalType
    
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.payment = paymentType
    #refTransId for which credit has to happen
    request.transactionRequest.refTransId = "2241762126"
    request.transactionRequest.transactionType = TransactionTypeEnum::RefundTransaction 
    response = transaction.create_transaction(request)
    
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          logger.info "Successful Credit Transaction (Transaction response code: #{response.transactionResponse.responseCode})"
          logger.info "Transaction Response code: #{response.transactionResponse.responseCode}"
          logger.info "Code: #{response.transactionResponse.messages.messages[0].code}"
		      logger.info "Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          logger.info "Transaction Failed"
          if response.transactionResponse.errors != nil
            logger.info "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            logger.info "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to authorize card."
        end
      else
        logger.info "Transaction Failed"
        if response.transactionResponse != nil && response.transactionResponse.errors != nil
          logger.info "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
          logger.info "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
        else
          logger.info "Error Code: #{response.messages.messages[0].code}"
          logger.info "Error Message: #{response.messages.messages[0].text}"
        end
        raise "Failed to authorize card."
      end
    else
      logger.info "Response is null"
      raise "Failed to authorize card."
    end    
    
    return response
  end

if __FILE__ == $0
  credit()
end