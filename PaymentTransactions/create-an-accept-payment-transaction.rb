require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def create_an_accept_payment_transaction()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.opaqueData = OpaqueDataType.new('COMMON.ACCEPT.INAPP.PAYMENT','119eyJjb2RlIjoiNTBfMl8wNjAwMDUyN0JEODE4RjQxOUEyRjhGQkIxMkY0MzdGQjAxQUIwRTY2NjhFNEFCN0VENzE4NTUwMjlGRUU0M0JFMENERUIwQzM2M0ExOUEwMDAzNzlGRDNFMjBCODJEMDFCQjkyNEJDIiwidG9rZW4iOiI5NDkwMjMyMTAyOTQwOTk5NDA0NjAzIiwidiI6IjEuMSJ9') 
    request.transactionRequest.customer = CustomerDataType.new(nil,nil,'bmc@mail.com')
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    request.transactionRequest.order = OrderType.new("invoiceNumber#{(SecureRandom.random_number*1000000).round(0)}","Order Description")    
    
    response = transaction.create_transaction(request)
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode})"
          puts "Transaction Response code: #{response.transactionResponse.responseCode}"
          puts "Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          puts "Transaction Failed"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to charge card."
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
        raise "Failed to charge card."
      end
    else
      puts "Response is null"
      raise "Failed to charge card."
    end
    
    return response
  end
  
if __FILE__ == $0
  create_an_accept_payment_transaction()
end