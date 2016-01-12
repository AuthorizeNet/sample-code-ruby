require 'rubygems'
  require 'yaml'
  require 'authorizenet' 
 require 'securerandom'

  include AuthorizeNet::API

  def get_transaction_Details()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    
      transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
      
      transId = "2239287784"
      request = GetTransactionDetailsRequest.new
      request.transId = transId
      
      #standard api call to retrieve response
      response = transaction.get_transaction_details(request)
      
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Get Transaction Details Successful " 
        puts "Transaction Id:   #{response.transaction.transId}"
        puts "Transaction Type:   #{response.transaction.transactionType}"
        puts "Transaction Status:   #{response.transaction.transactionStatus}"
        printf("Auth Amount:  %.2f\n", response.transaction.authAmount)
        printf("Settle Amount:  %.2f\n", response.transaction.settleAmount)
      else
        puts response.messages.messages[0].code
        puts response.messages.messages[0].text
        raise "Failed to get transaction Details."
      end
    
    return response
end
  
  
if __FILE__ == $0
  get_transaction_Details()
end