require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  
  request = UpdateCustomerPaymentProfileRequest.new

  payment = PaymentType.new(CreditCardType.new('4111111111111111','2025-05'))
  profile = CustomerPaymentProfileExType.new(nil,nil,payment,nil,nil)

  request.paymentProfile = profile
  request.customerProfileId = '35894174'
  profile.customerPaymentProfileId = '33605803'

  response = transaction.update_customer_payment_profile(request)


  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully updated customer payment profile with  id #{request.paymentProfile.customerPaymentProfileId}"
  else
    puts response.messages.messages[0].text
    raise "Failed to update customer with customer payment profile id #{request.paymentProfile.customerPaymentProfileId}"
  end