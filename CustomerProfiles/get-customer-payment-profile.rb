require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = GetCustomerPaymentProfileRequest.new
  request.customerProfileId = '36152115'
  request.customerPaymentProfileId = '32689262'

  response = transaction.get_customer_payment_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully retrieved a payment profile with profile id is #{request.customerPaymentProfileId} and whose customer id is #{request.customerProfileId}"
    puts "First name in billing address: #{response.paymentProfile.billTo.firstName}"
    puts "Masked Credit card number: #{response.paymentProfile.payment.creditCard.cardNumber}"
  else
    puts response.messages.messages[0].text
    raise "Failed to get payment profile information with id #{request.customerPaymentProfileId}"
  end