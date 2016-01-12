require 'rubygems'
  require 'yaml'
  require 'authorizenet' 
 require 'securerandom'

  include AuthorizeNet::API

  def capture_funds_authorized_through_another_channel()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = SecureRandom.random_number.round(3)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new('4111111111111111','0718') 
    request.transactionRequest.transactionType = TransactionTypeEnum::CaptureOnlyTransaction
    request.transactionRequest.authCode = "ROHNFQ"
    
    response = transaction.create_transaction(request)
  
    if response.messages.resultCode == MessageTypeEnum::Ok
      if response.transactionResponse != nil
        puts "Success, Auth Code : #{response.transactionResponse.authCode}"
      end
    else
      puts response.messages.messages[0].text
      puts response.transactionResponse.errors.errors[0].errorCode
      puts response.transactionResponse.errors.errors[0].errorText
      raise "Failed to charge card."
    end
    
    return response
  end
  
if __FILE__ == $0
  capture_funds_authorized_through_another_channel()
end