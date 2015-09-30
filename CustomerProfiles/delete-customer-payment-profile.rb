require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = DeleteCustomerPaymentProfileRequest.new
  request.customerProfileId = '35894174'
  request.customerPaymentProfileId = '33604709'

  response = transaction.delete_customer_payment_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully deleted payment profile with customer payment profile id #{request.customerPaymentProfileId}"
  else
    puts "Failed to delete payment profile with profile id #{request.customerPaymentProfileId} : #{response.messages.messages[0].text}"
  end