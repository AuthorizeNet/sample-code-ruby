require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_transaction_List()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
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
          puts "#{response.messages.messages[0].text}"
        else
          puts "Successfully got the list of transactions for batch " + batchId + "."          
          response.transactions.transaction.each do |trans|
            puts "Transaction ID: #{trans.transId} "
            puts "  Submitted on (Local): %s " % [trans.submitTimeUTC]
            puts "  Status: #{trans.transactionStatus} "
            puts "  Settle Amount: %.2f " % [trans.settleAmount]
          end
        end
      else
        puts "Error: Failed to get Transaction List."
        puts "Error Text: #{response.messages.messages[0].text}"
        puts "Error Code: #{response.messages.messages[0].code}"
      end
    else
      puts "Error: Failed to get Transaction List."
      puts "Error Text: #{response.messages.messages[0].text}"
      puts "Error Code: #{response.messages.messages[0].code}"
    end

    return response
  
  end
  
  
if __FILE__ == $0
  get_transaction_List()
end
