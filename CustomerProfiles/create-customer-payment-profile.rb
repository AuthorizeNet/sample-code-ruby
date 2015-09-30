require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = CreateCustomerPaymentProfileRequest.new
  
  payment = PaymentType.new(CreditCardType.new('4111111111111111','2020-05'))
  profile = CustomerPaymentProfileType.new(nil,nil,payment,nil,nil)

  request.paymentProfile = profile
  request.customerProfileId = '35894174'
  response = transaction.create_customer_payment_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully created a customer payment profile with id:  #{response.customerPaymentProfileId}"
  else
    puts "Failed to create a new customer payment profile: #{response.messages.messages[0].text}"
  end