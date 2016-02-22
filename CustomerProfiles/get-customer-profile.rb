require 'rubygems'
  require 'yaml'
  require 'authorizenet' 

 require 'securerandom'

  include AuthorizeNet::API

  def get_customer_profile(customerProfileId = '36152115')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = GetCustomerProfileRequest.new
    request.customerProfileId = customerProfileId

    response = transaction.get_customer_profile(request)

    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully retrieved a customer with profile id is #{request.customerProfileId} and whose customer id is #{response.profile.merchantCustomerId}"
      response.profile.paymentProfiles.each do |paymentProfile|
        puts "Payment Profile ID #{paymentProfile.customerPaymentProfileId}" 
        puts "Payment Details:"
        puts "Last Name #{paymentProfile.billTolastName}"
        puts "Address #{paymentProfile.billTo.address}"    
      end
      response.profile.shipToList.each do |ship|
        puts "Shipping Details:"
        puts "First Name #{ship.firstName}"
        puts "Last Name #{ship.lastName}"
        puts "Address #{ship.address}"
        puts "Customer Address ID #{ship.customerAddressId}"
      end
    else
      puts response.messages.messages[0].text
      raise "Failed to get customer profile information with id #{request.customerProfileId}"
    end
    return response
  end
  
if __FILE__ == $0
  get_customer_profile()
end
  
