require 'rubygems'
  require 'yaml'
  require 'authorizenet' 
 require 'securerandom'

  include AuthorizeNet::API

  def get_details()
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
    request.transactionRequest.payment = paymentType
    request.transactionRequest.refTransId = "2242023171"
    request.transactionRequest.transactionType = TransactionTypeEnum::GetDetailsTransaction
    
    response = transaction.create_transaction(request)
    
    #// If API Response is ok, go ahead and check the transaction response
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Paypal Get Details successful."
      puts "Response Code : #{response.transactionResponse.responseCode}"
      puts "Shipping address : #{response.transactionResponse.shipTo.address}, #{response.transactionResponse.shipTo.city}, #{response.transactionResponse.shipTo.state}, #{response.transactionResponse.shipTo.country}"
      if response.transactionResponse.secureAcceptance != nil
        puts "Payer ID : #{response.transactionResponse.secureAcceptance.PayerID}"
      end
    else
      puts response.messages.messages[0].text
      puts response.transactionResponse.errors.errors[0].errorCode
      puts response.transactionResponse.errors.errors[0].errorText
      raise "Paypal Get Details failed."
    end
    
    return response
  
end
  
if __FILE__ == $0
  get_details()
end
