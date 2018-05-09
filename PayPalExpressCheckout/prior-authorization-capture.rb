require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API
  
  def prior_authorization_capture()
    logger.info "PayPal Prior Authorization Transaction"
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    random_amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.amount = random_amount
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new('4242424242424242','0220','123') 
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthOnlyTransaction
    
    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          logger.info "Successful AuthOnly Transaction (authorization code: #{response.transactionResponse.authCode})"
          refTransId =  response.transactionResponse.transId
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

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    payPalType = PayPalType.new
    payPalType.successUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    payPalType.cancelUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    
    paymentType = PaymentType.new
    paymentType.payPal = payPalType
      
    request = CreateTransactionRequest.new
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.refTransId = refTransId
    random_amount = random_amount
    request.transactionRequest.amount = random_amount
    request.transactionRequest.payment = paymentType
    request.transactionRequest.transactionType = TransactionTypeEnum::PriorAuthCaptureTransaction
    
    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          logger.info "Successfully created a Prior Authorization capture transaction (authorization code: #{response.transactionResponse.authCode})"
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
  prior_authorization_capture()
end
