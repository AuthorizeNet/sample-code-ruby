require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_Transaction_List_For_Customer(customerProfileId = '40036377')
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
    		logger.info "#{response.messages.messages[0].text}"
    	else
        response.transactions.transaction.each do |trans|
  	  		logger.info "\nTransaction ID :  #{trans.transId} "
  	  		logger.info "Submitted on (Local) :  %s " % [trans.submitTimeUTC]
  	  		logger.info "Status :  #{trans.transactionStatus} "
  	  		logger.info "Settle Amount :  %.2f " % [trans.settleAmount]
  	  	end
    	end
    else
    	logger.info "Error: Failed to get Transaction List for customer\n"
    	logger.info "Error Text :  #{response.messages.messages[0].text} \n"
    	logger.info "Error Code :  #{response.messages.messages[0].code} "
    end
    return response
  
  end
  
  
if __FILE__ == $0
  get_Transaction_List_For_Customer()
end
