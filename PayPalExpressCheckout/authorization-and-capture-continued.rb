require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API
  
  def authorization_and_capture_continued()
    logger.info "PayPal Authorization Capture-Continue Transaction"
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    payPalType = PayPalType.new
    payPalType.successUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    payPalType.cancelUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    payPalType.payerID = "M8R9JRNJ3R28Y"
    
    paymentType = PaymentType.new
    paymentType.payPal = payPalType
        
    request = CreateTransactionRequest.new
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.refTransId = "2241762169"
    request.transactionRequest.amount = 15.00
    request.transactionRequest.payment = paymentType
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureContinueTransaction
    
    response = transaction.create_transaction(request)
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          logger.info "Successfully created an Authorization Capture-Continue transaction (authorization code: #{response.transactionResponse.authCode})"
          logger.info "Transaction Response code: #{response.transactionResponse.responseCode}"
          logger.info "Code: #{response.transactionResponse.messages.messages[0].code}"
		      logger.info "Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          logger.info "Transaction Failed"
          if response.transactionResponse.errors != nil
            logger.info "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            logger.info "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to make purchase."
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
        raise "Failed to make purchase."
      end
    else
      logger.info "Response is null"
      raise "Failed to make purchase."
    end

    return response
  
  end  
  
if __FILE__ == $0
  authorization_and_capture_continued()
end