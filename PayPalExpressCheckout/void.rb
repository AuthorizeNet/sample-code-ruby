require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_transId()
    # Before we can void a transaction, we must first create a transaction,
    # so that we have something to void.
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new('4242424242424242','0220','123') 
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    
    response = transaction.create_transaction(request)
    authTransId = 0

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          puts "Successful AuthCapture Transaction (authorization code: #{response.transactionResponse.authCode})"
          authTransId = response.transactionResponse.transId
          puts "  Transaction ID (for later void: #{authTransId})"
          puts "  Transaction Response code: #{response.transactionResponse.responseCode}"
          puts "  Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "  Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          puts "Transaction Failed"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to authorize card."
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
        raise "Failed to authorize card."
      end
    else
      puts "Response is null"
      raise "Failed to authorize card."
    end
    return authTransId
  end

  def void(authTransId)
    # This function will take the transaction ID from the previously created transaction
    # and send a void request for that transaction ID.
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.refTransId = authTransId
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.payPal = PayPalType.new()
    request.transactionRequest.transactionType = TransactionTypeEnum::VoidTransaction
    
    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          puts "Successfully voided the transaction (Transaction ID: #{response.transactionResponse.transId})"
          puts "  Transaction Response code: #{response.transactionResponse.responseCode}"
          puts "  Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "  Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          puts "Transaction Failed"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to void the transaction."
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
        raise "Failed to void the transaction."
      end
    else
      puts "Response is null"
      raise "Failed to void the transaction."
    end
    
    return response  
  end

if __FILE__ == $0
  authTransId = get_transId()
  void(authTransId)
end
