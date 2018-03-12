require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_details(transId)
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
    request.transactionRequest.refTransId = transId
    request.transactionRequest.transactionType = TransactionTypeEnum::GetDetailsTransaction
    
    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && (response.transactionResponse.messages != nil)
          puts "Paypal Get Details successful."
          puts "Response Code: #{response.transactionResponse.responseCode}"
          puts "Shipping address: #{response.transactionResponse.shipTo.address}, #{response.transactionResponse.shipTo.city}, #{response.transactionResponse.shipTo.state}, #{response.transactionResponse.shipTo.country}"
          if response.transactionResponse.secureAcceptance != nil
            puts "Payer ID: #{response.transactionResponse.secureAcceptance.PayerID}"
          end
          puts "Transaction Response code: #{response.transactionResponse.responseCode}"
          puts "Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          puts "Transaction Failed"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
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
      end
    else
      puts "Response is null"
    end
    
    return response
  
  end
  
if __FILE__ == $0
  get_details()
end
