require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_customer_profile(customerProfileId = '40036377')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = GetCustomerProfileRequest.new
    request.customerProfileId = customerProfileId

    response = transaction.get_customer_profile(request)

    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully retrieved a customer with profile ID is #{request.customerProfileId} and whose customer ID is #{response.profile.merchantCustomerId}."
      response.profile.paymentProfiles.each do |paymentProfile|
        puts "  Payment Profile ID #{paymentProfile.customerPaymentProfileId}" 
        puts "  Payment Details:"
        if paymentProfile.billTo != nil
          puts "    Last Name: #{paymentProfile.billTo.lastName}"
          puts "    Address: #{paymentProfile.billTo.address}"    
        end
      end
      response.profile.shipToList.each do |ship|
        puts "  Shipping Address ID #{ship.customerAddressId}"
        puts "  Shipping Details:"
        puts "    First Name: #{ship.firstName}"
        puts "    Last Name: #{ship.lastName}"
        puts "    Address: #{ship.address}"
      end

      if response.subscriptionIds != nil && response.subscriptionIds.subscriptionId != nil
        puts "  List of subscriptions: "
        response.subscriptionIds.subscriptionId.each do |subscriptionId|
          puts "    #{subscriptionId}"
        end
      end

    else
      puts response.messages.messages[0].text
      raise "Failed to get customer profile information with ID #{request.customerProfileId}"
    end
    return response
  end
  
if __FILE__ == $0
  get_customer_profile()
end
  
