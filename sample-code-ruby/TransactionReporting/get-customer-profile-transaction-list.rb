require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_Transaction_List_For_Customer(customerProfileId = '40036377')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction1 = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    request = AuthorizeNet::API::GetTransactionListForCustomerRequest.new
    request.customerProfileId = customerProfileId
    request.paging = Paging.new;
    request.paging.limit = 10;
    request.paging.offset = 1;

    request.sorting = TransactionListSorting.new;
    request.sorting.orderBy = "id";
    request.sorting.orderDescending = true;

    response = transaction1.get_transaction_list_for_customer(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
    	transactions = response.transactions
    	if transactions == nil
    		puts "#{response.messages.messages[0].text}"
    	else
        response.transactions.transaction.each do |trans|
  	  		puts "\nTransaction ID :  #{trans.transId} "
  	  		puts "Submitted on (Local) :  %s " % [trans.submitTimeUTC]
  	  		puts "Status :  #{trans.transactionStatus} "
  	  		puts "Settle Amount :  %.2f " % [trans.settleAmount]
  	  	end
    	end
    else
    	puts "Error: Failed to get Transaction List for customer\n"
    	puts "Error Text :  #{response.messages.messages[0].text} \n"
    	puts "Error Code :  #{response.messages.messages[0].code} "
    end
    return response
  
  end
  
  
if __FILE__ == $0
  get_Transaction_List_For_Customer()
end
