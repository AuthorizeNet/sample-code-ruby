require 'rubygems'
require 'yaml'
require 'authorizenet'

  include AuthorizeNet::Reporting

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  #batchId = "4606008"
  batchId = "4551107"

  response = transaction.get_transaction_list(batchId)

  if response.result_code == "Ok"
  	transactions = response.transactions
  	if transactions == nil
  		puts "#{response.message_text}"
  	else
	  	transactions.each do |transaction|
	  		puts "\nTransaction ID  :  #{transaction.id} "
	  		puts "Submitted on (Local)  :  %s " %[transaction.submitted_at.strftime("%m/%d/%Y  %I:%M:%S %p")]
	  		puts "Status  :  #{transaction.status} "
	  		puts "Settle Amount  :  %.2f " %[transaction.settle_amount]
	  	end
  	end
  else
  	puts "Error : Failed to get Transaction List\n"
  	puts "Error Text  :  #{response.message_text} \n"
  	puts "Error Code  :  #{response.message_code} "
  end
