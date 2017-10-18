require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def delete_customer_payment_profile(customerProfileId='35894174', customerPaymentProfileId='33604709')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = DeleteCustomerPaymentProfileRequest.new
    request.customerProfileId = customerProfileId
    request.customerPaymentProfileId = customerPaymentProfileId

    response = transaction.delete_customer_payment_profile(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully deleted payment profile with customer payment profile ID #{request.customerPaymentProfileId}."
    else
      puts "Failed to delete payment profile with profile ID #{request.customerPaymentProfileId}: #{response.messages.messages[0].text}"
    end
    return response
  end

if __FILE__ == $0
  delete_customer_payment_profile()
end

