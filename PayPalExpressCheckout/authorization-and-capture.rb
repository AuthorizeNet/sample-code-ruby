require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def authorization_and_capture()
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    # Define the PayPal specific parameters
    payPalType = PayPalType.new()
    payPalType.successUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    payPalType.cancelUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    
    paymentType = PaymentType.new()
    paymentType.payPal = payPalType

    # Construct the request object
    request = CreateTransactionRequest.new
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.payment = paymentType
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    
    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && (response.transactionResponse.responseCode == "1" || response.transactionResponse.responseCode == "5")
          logger.info "Successfully created an authorize and capture transaction."
          logger.info "  Response Code: #{response.transactionResponse.responseCode}" 
          logger.info "  Transaction ID: #{response.transactionResponse.transId}"
          logger.info "  Secure Acceptance URL: #{response.transactionResponse.secureAcceptance.SecureAcceptanceUrl}"
          logger.info "  Transaction Response code: #{response.transactionResponse.responseCode}"
          logger.info "  Code: #{response.transactionResponse.messages.messages[0].code}"
		      logger.info "  Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          logger.info "PayPal authorize and capture transaction failed"
          if response.transactionResponse.errors != nil
            logger.info "  Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            logger.info "  Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed PayPal Authorize Capture Transaction."
        end
      else
        logger.info "PayPal authorize and capture transaction failed"
        if response.transactionResponse != nil && response.transactionResponse.errors != nil
          logger.info "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
          logger.info "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
        else
          logger.info "Error Code: #{response.messages.messages[0].code}"
          logger.info "Error Message: #{response.messages.messages[0].text}"
        end
        raise "Failed PayPal Authorize Capture Transaction."
      end
    else
      logger.info "Response is null"
      raise "Failed PayPal Authorize Capture Transaction."
    end
    
    return response
  
  end

if __FILE__ == $0
  authorization_and_capture()
end
