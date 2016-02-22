require 'rubygems'
  require 'yaml'
  require 'authorizenet' 

 require 'securerandom'

  include AuthorizeNet::API

  def charge_tokenized_credit_card()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new('4242424242424242','0220','123',nil,"EjRWeJASNFZ4kBI0VniQEjRWeJA=") 
   
    
    response = transaction.create_transaction(request)
  
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully charged tokenized credit card (authorization code: #{response.transactionResponse.authCode})"
  
    else
      puts response.messages.messages[0].text
      puts response.transactionResponse.errors.errors[0].errorCode
      puts response.transactionResponse.errors.errors[0].errorText
      raise "Failed to make charge tokenized credit card."
    end
    
    return response
end
  
if __FILE__ == $0
  charge_tokenized_credit_card()
end