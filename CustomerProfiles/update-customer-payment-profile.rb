require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def update_customer_payment_profile(customerProfileId = '35894174', customerPaymentProfileId = '33605803')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    request = UpdateCustomerPaymentProfileRequest.new

    payment = PaymentType.new(CreditCardType.new('4111111111111111','2025-05'))
    profile = CustomerPaymentProfileExType.new(nil,nil,payment,nil,nil)

    request.paymentProfile = profile
    request.customerProfileId = customerProfileId
    profile.customerPaymentProfileId = customerPaymentProfileId

    response = transaction.update_customer_payment_profile(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully updated customer payment profile with  ID #{request.paymentProfile.customerPaymentProfileId}."
    else
      puts response.messages.messages[0].text
      raise "Failed to update customer with customer payment profile ID #{request.paymentProfile.customerPaymentProfileId}."
    end
    return response
  end
  
if __FILE__ == $0
  update_customer_payment_profile()
end

