require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::Reporting

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
  #create getDetails Transaction for a Valid Transaction ID
  response = transaction.get_transaction_details("2239287784")
  transaction = response.transaction
  
  if response.result_code == "Ok" 
    puts "Get Transaction Details Successful " 
    puts "Transaction Id:   #{transaction.id}"
    puts "Transaction Type:   #{transaction.type}"
    puts "Transaction Status:   #{transaction.status}"
    printf("Auth Amount:  %.2f\n",transaction.auth_amount)
    printf("Settle Amount:  %.2f\n",transaction.settle_amount)
  else
    puts "ERROR message: #{response.message_text}"
    puts "ERROR code: #{response.message_code}"
    raise "Failed to get transaction Details."
  end