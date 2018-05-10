require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def credit_bank_account()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 15 ).round(2)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.bankAccount = BankAccountType.new('checking','125008547','1234567890', 'John Doe','PPD','Wells Fargo Bank NA','101') 
    request.transactionRequest.transactionType = TransactionTypeEnum::RefundTransaction
    
    response = transaction.create_transaction(request)
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && (response.transactionResponse.messages != nil)
          puts "Successfully credited (Transaction ID: #{response.transactionResponse.transId})"
          puts "Transaction Response code: #{response.transactionResponse.responseCode}"
          puts "Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          puts "Transaction Failed"
          puts "Transaction Response code: #{response.transactionResponse.responseCode}"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          puts "Failed to credit bank account."
        end
      else
        puts "Transaction Failed"
        if response.transactionResponse != nil && response.transactionResponse.errors != nil
          puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
          puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
        else
          puts "Error Code: #{response.messages.messages[0].code}"
          puts "Error Message: #{response.messages.messages[0].text}"
        end
        puts "Failed to credit bank account."
      end
    else
      puts "Response is null"
      raise "Failed to credit bank account."
    end
        
    return response
  end
  
if __FILE__ == $0
  credit_bank_account()
end
