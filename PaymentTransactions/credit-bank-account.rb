require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  def credit_bank_account()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = Random.new(Random.new_seed).rand.round(3)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.bankAccount = BankAccountType.new(nil,'125000024','12345678', 'John Doe') 
    request.transactionRequest.transactionType = TransactionTypeEnum::RefundTransaction
    
    
    response = transaction.create_transaction(request)
  
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully credited (Transaction ID: #{response.transactionResponse.transId})"
  
    else
      puts response.messages.messages[0].text
      puts response.transactionResponse.errors.errors[0].errorCode
      puts response.transactionResponse.errors.errors[0].errorText
      raise "Failed to make refund."
    end
    
    return response
end
  
if __FILE__ == $0
  credit_bank_account()
end