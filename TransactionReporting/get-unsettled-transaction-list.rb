require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::Reporting

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  #merchant information
  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  #get response from service
  response = transaction.get_unsettled_transaction_list

  if response.result_code == "Ok"
    unsettled_transactions = response.transactions
  
    unsettled_transactions.each do |unsettled_transaction|
      puts "Transaction #{unsettled_transaction.id} was submitted at #{unsettled_transaction.submitted_at}"
    end    
  else
    puts "ERROR message: #{response.message_text}"
    puts "ERROR code: #{response.message_code}"
    raise "Failed to get unsettled transaction list."
  end