require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_transaction_List()
    transaction1 = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    batchId = "7590305"
    request = AuthorizeNet::API::GetTransactionListRequest.new
    request.batchId = batchId
    request.paging = Paging.new;
    # Paging limit can be up to 1000 for this request
    request.paging.limit = '20'
    request.paging.offset = 1;

    request.sorting = TransactionListSorting.new;
    request.sorting.orderBy = TransactionListOrderFieldEnum::Id;
    request.sorting.orderDescending = true;

    response = transaction1.get_transaction_list(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactions == nil
          logger.info "#{response.messages.messages[0].text}"
        else
          logger.info "Successfully got the list of transactions for batch " + batchId + "."          
          response.transactions.transaction.each do |trans|
            logger.info "Transaction ID: #{trans.transId} "
            logger.info "  Submitted on (Local): %s " % [trans.submitTimeUTC]
            logger.info "  Status: #{trans.transactionStatus} "
            logger.info "  Settle Amount: %.2f " % [trans.settleAmount]
          end
        end
      else
        logger.info "Error: Failed to get Transaction List."
        logger.info "Error Text: #{response.messages.messages[0].text}"
        logger.info "Error Code: #{response.messages.messages[0].code}"
      end
    else
      logger.info "Error: Failed to get Transaction List."
      logger.info "Error Text: #{response.messages.messages[0].text}"
      logger.info "Error Code: #{response.messages.messages[0].code}"
    end

    return response
  
  end
  
  
if __FILE__ == $0
  get_transaction_List()
end
