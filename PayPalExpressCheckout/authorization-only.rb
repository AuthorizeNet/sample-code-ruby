require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def authorization_only()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
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
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthOnlyTransaction
    
    response = transaction.create_transaction(request)

  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && (response.transactionResponse.responseCode == "1" || response.transactionResponse.responseCode == "5")
          puts "Successfully created an authorize only transaction."
          puts "  Response Code: #{response.transactionResponse.responseCode}" 
          puts "  Transaction ID: #{response.transactionResponse.transId}"
          puts "  Secure Acceptance URL: #{response.transactionResponse.secureAcceptance.SecureAcceptanceUrl}"
          puts "  Transaction Response code: #{response.transactionResponse.responseCode}"
          puts "  Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "  Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          puts "PayPal authorize only transaction failed"
          if response.transactionResponse.errors != nil
            puts "  Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "  Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed PayPal Authorize Only Transaction."
        end
      else
        puts "PayPal authorize only transaction failed"
        if response.transactionResponse != nil && response.transactionResponse.errors != nil
          puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
          puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
        else
          puts "Error Code: #{response.messages.messages[0].code}"
          puts "Error Message: #{response.messages.messages[0].text}"
        end
        raise "Failed PayPal Authorize Only Transaction."
      end
    else
      puts "Response is null"
      raise "Failed PayPal Authorize Only Transaction."
    end    
    
    return response
  
  end 

if __FILE__ == $0
  authorization_only()
end
