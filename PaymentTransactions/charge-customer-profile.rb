require 'rubygems'
  require 'yaml'
  require 'authorizenet' 
 require 'securerandom'

  include AuthorizeNet::API

  def charge_customer_profile()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = SecureRandom.random_number.round(3)
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    request.transactionRequest.profile = CustomerProfilePaymentType.new()
    request.transactionRequest.profile.customerProfileId = "36731856"
    request.transactionRequest.profile.paymentProfile = PaymentProfile.new("33211899")
  
    response = transaction.create_transaction(request)
  
    if response.messages.resultCode == MessageTypeEnum::Ok
      if response.transactionResponse != nil
        puts "Success, Auth Code : #{response.transactionResponse.authCode}"
      end
    else
      puts response.messages.messages[0].text
      raise "Failed to charge customer profile."
    end
    
    return response
end
  
if __FILE__ == $0
  charge_customer_profile()
end