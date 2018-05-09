require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_unsettled_transaction_List()
      #merchant information
      transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
      
      request = GetUnsettledTransactionListRequest.new

      request.status  = TransactionGroupStatusEnum::ANY;
      request.paging = Paging.new;
      # Paging limit can be up to 1000
      request.paging.limit = '20'
      request.paging.offset = 1;

      request.sorting = TransactionListSorting.new;
      request.sorting.orderBy = TransactionListOrderFieldEnum::Id;
      request.sorting.orderDescending = true;
      
      response = transaction.get_unsettled_transaction_list(request)
      
      if response.messages.resultCode == MessageTypeEnum::Ok
        unsettled_transactions = response.transactions
      
        response.transactions.transaction.each do |unsettled_transaction|
          logger.info "Transaction #{unsettled_transaction.transId} was submitted at #{unsettled_transaction.submitTimeUTC}"
          
        end
        logger.info "Total transaction received #{unsettled_transactions.transaction.length}"
      else
        logger.info "ERROR message: #{response.messages.messages[0].text}"
        logger.info "ERROR code: #{response.messages.messages[0].code}"
        raise "Failed to get unsettled transaction list."
      end
    
    return response
  end
  
  
if __FILE__ == $0
  get_unsettled_transaction_List()
end