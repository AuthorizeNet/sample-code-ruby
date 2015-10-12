require 'rubygems'
  require 'yaml'
  require 'authorizenet'
  require "date"

  include AuthorizeNet::Reporting

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  firstSettlementDate = Date.today - 31
  lastSettlementDate = Date.today

  puts "First settlement date: #{firstSettlementDate} Last settlement date: #{lastSettlementDate}"

  response = transaction.get_settled_batch_list(from_date=DateTime.now()-(1 * 24), to_date=DateTime.now(), include_status=true)
    
  if response.result_code == "Ok"
  	#puts "#{response.batch_list.to_yaml}"
  	batchList = response.batch_list
  	
  	for child in batchList
  		puts "Transaction Id: #{child.id}"
      puts "Settlement Date: #{child.settled_at}"
      puts "State: #{child.state}"
      puts "Account Type: #{child.statistics[0].account_type}"
      puts ""
  	end
  else
    puts response.message_text
    raise "Failed to fetch transaction list"
  end
