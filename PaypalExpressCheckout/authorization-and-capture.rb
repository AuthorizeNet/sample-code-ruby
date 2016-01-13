require 'rubygems'
  require 'yaml'
  require 'authorizenet' 

 require 'securerandom'

  include AuthorizeNet::API

  def authorization_and_capture()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
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
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    
    response = transaction.create_transaction(request)
    
    #// If API Response is ok, go ahead and check the transaction response
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successful Paypal Authorize Capture Transaction."
      puts "Response Code : #{response.transactionResponse.responseCode}" 
      puts "Transaction ID : #{response.transactionResponse.transId}"
      puts "Secure Acceptance URL : #{response.transactionResponse.secureAcceptance.SecureAcceptanceUrl}"
    else
      puts response.messages.messages[0].text
      puts response.transactionResponse.errors.errors[0].errorCode
      puts response.transactionResponse.errors.errors[0].errorText
      raise "Failed Paypal Authorize Capture Transaction."
    end
    
    return response
  
end

  
if __FILE__ == $0
  authorization_and_capture()
end
