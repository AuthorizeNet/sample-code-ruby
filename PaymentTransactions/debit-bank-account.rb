require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def debit_bank_account()
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 15 ).round(2)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.bankAccount = BankAccountType.new('checking','125008547','1234567890', 'John Doe','WEB','Wells Fargo Bank NA','101') 
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    request.transactionRequest.order = OrderType.new("invoiceNumber#{(SecureRandom.random_number*1000000).round(0)}","Order Description")    

    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && (response.transactionResponse.messages != nil)
          logger.info "Successfully debited bank account."
          logger.info "  Transaction ID: #{response.transactionResponse.transId}"
          logger.info "  Transaction response code: #{response.transactionResponse.responseCode}"
          logger.info "  Code: #{response.transactionResponse.messages.messages[0].code}"
		      logger.info "  Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          logger.info "Transaction Failed"
          logger.info "Transaction response code: #{response.transactionResponse.responseCode}"          
          if response.transactionResponse.errors != nil
            logger.info "  Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            logger.info "  Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          logger.info "Failed to debit bank account."
        end
      else
        logger.info "Transaction Failed"
        if response.transactionResponse != nil && response.transactionResponse.errors != nil
          logger.info "  Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
          logger.info "  Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
        else
          logger.info "  Error Code: #{response.messages.messages[0].code}"
          logger.info "  Error Message: #{response.messages.messages[0].text}"
        end
        logger.info "Failed to debit bank account."
      end
    else
      logger.info "Response is null"
      raise "Failed to debit bank account."
    end

    return response
  end
  
if __FILE__ == $0
  debit_bank_account()
end
