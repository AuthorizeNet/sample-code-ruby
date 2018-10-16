require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def create_visa_checkout_transaction()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = 16.00
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.opaqueData = OpaqueDataType.new('COMMON.VCO.ONLINE.PAYMENT','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')
    request.transactionRequest.callId = '2751969838440085201'
    
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
  
    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          puts "Successfully made a purchase (authorization code: #{response.transactionResponse.authCode})"
          puts "Transaction Response code: #{response.transactionResponse.responseCode}"
          puts "Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          puts "Transaction Failed"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to make purchase."
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
        raise "Failed to make purchase."
      end
    else
      puts "Response is null"
      raise "Failed to make purchase."
    end
      
    return response
  end

  
if __FILE__ == $0
  create_visa_checkout_transaction()
end
