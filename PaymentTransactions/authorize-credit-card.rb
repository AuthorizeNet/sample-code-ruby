require 'rubygems'
  require 'yaml'
  require 'authorizenet' 

 require 'securerandom'

  include AuthorizeNet::API

  def authorize_credit_card()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new('4242424242424242','0220','123') 
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthOnlyTransaction

    userFieldArr = Array.new
    userField = UserField.new('userFieldName','userFieldvalue')
    userFieldArr.push(userField)
    userField = UserField.new('userFieldName1','userFieldvalue1')
    userFieldArr.push(userField)

    request.transactionRequest.userFields = UserFields.new(userFieldArr)
    
    response = transaction.create_transaction(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successful AuthOnly Transaction (authorization code: #{response.transactionResponse.authCode})"
      response.transactionResponse.userFields.userFields.each do |userField|
        puts userField.value
      end
    else
      puts response.messages.messages[0].text
      puts response.transactionResponse.errors.errors[0].errorCode
      puts response.transactionResponse.errors.errors[0].errorText
      raise "Failed to authorize card."
    end
    return response
  end
  
if __FILE__ == $0
  authorize_credit_card()
end