require 'rubygems'
  require 'yaml'
  require 'authorizenet'
  require "date"

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  firstSettlementDate = DateTime.now()-(1 * 24)
  lastSettlementDate = DateTime.now()

  puts "First settlement date: #{firstSettlementDate} Last settlement date: #{lastSettlementDate}"
  
  request = GetSettledBatchListRequest.new
  request.firstSettlementDate = firstSettlementDate
  request.lastSettlementDate = lastSettlementDate
  request.includeStatistics = true

  response = transaction.get_settled_batch_list(request)
    
  if response.messages.resultCode == MessageTypeEnum::Ok
  	
  	response.batchList.batch.each do |batch|
  		puts "Transaction Id: #{batch.batchId}"
      puts "Settlement Date: #{batch.settlementTimeUTC}"
      puts "State: #{batch.settlementState}"
      puts "Account Type: #{batch.statistics[0].accountType}"
      puts ""
  	end
  else
      puts response.messages.messages[0].code
      puts response.messages.messages[0].text
    raise "Failed to fetch settled batch list"
  end
