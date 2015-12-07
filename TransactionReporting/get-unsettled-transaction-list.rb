require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  #merchant information
  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
  request = GetUnsettledTransactionListRequest.new
  
  response = transaction.get_unsettled_transaction_list(request)
  
  if response.messages.resultCode == MessageTypeEnum::Ok
    unsettled_transactions = response.transactions
  
    response.transactions.transaction.each do |unsettled_transaction|
      puts "Transaction #{unsettled_transaction.transId} was submitted at #{unsettled_transaction.submitTimeUTC}"
      
    end
    puts "Total transaction received #{unsettled_transactions.transaction.length}"
  else
    puts "ERROR message: #{response.message_text}"
    puts "ERROR code: #{response.message_code}"
    raise "Failed to get unsettled transaction list."
  end