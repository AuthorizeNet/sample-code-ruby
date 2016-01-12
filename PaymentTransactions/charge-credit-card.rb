require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  def charge_credit_card()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = Random.new(Random.new_seed).rand.round(3)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new('4242424242424242','0220','123') 
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    
    response = transaction.create_transaction(request)
  
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode})"
  
    else
      puts response.messages.messages[0].text
      puts response.transactionResponse.errors.errors[0].errorCode
      puts response.transactionResponse.errors.errors[0].errorText
      raise "Failed to charge card."
    end
    
    return response
end
  
if __FILE__ == $0
  charge_credit_card()
end