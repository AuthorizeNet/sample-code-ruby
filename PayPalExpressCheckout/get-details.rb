require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_details(transId)
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
    
    payPalType = PayPalType.new()
    payPalType.successUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    payPalType.cancelUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
    
    #standard api call to retrieve response
    paymentType = PaymentType.new()
    paymentType.payPal = payPalType
    
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.payment = paymentType
    request.transactionRequest.refTransId = transId
    request.transactionRequest.transactionType = TransactionTypeEnum::GetDetailsTransaction
    
    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && (response.transactionResponse.messages != nil)
          logger.info "Paypal Get Details successful."
          logger.info "Response Code: #{response.transactionResponse.responseCode}"
          logger.info "Shipping address: #{response.transactionResponse.shipTo.address}, #{response.transactionResponse.shipTo.city}, #{response.transactionResponse.shipTo.state}, #{response.transactionResponse.shipTo.country}"
          if response.transactionResponse.secureAcceptance != nil
            logger.info "Payer ID: #{response.transactionResponse.secureAcceptance.PayerID}"
          end
          logger.info "Transaction Response code: #{response.transactionResponse.responseCode}"
          logger.info "Code: #{response.transactionResponse.messages.messages[0].code}"
		      logger.info "Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          logger.info "Transaction Failed"
          if response.transactionResponse.errors != nil
            logger.info "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            logger.info "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
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
      end
    else
      logger.info "Response is null"
    end
    
    return response
  
  end
  
if __FILE__ == $0
  get_details()
end
