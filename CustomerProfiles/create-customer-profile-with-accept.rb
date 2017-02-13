require 'rubygems'
  require 'yaml'
  require 'authorizenet' 

 require 'securerandom'

  include AuthorizeNet::API

  def create_customer_profile_with_accept()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")


    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)


    request = CreateCustomerProfileRequest.new
    payment = PaymentType.new
    payment.opaqueData = OpaqueDataType.new('COMMON.ACCEPT.INAPP.PAYMENT','9487004388327322604603',nil)
    profile = CustomerPaymentProfileType.new(nil,nil,payment,nil,nil)

    request.profile = CustomerProfileType.new('jdoe'+rand(10000).to_s,'John2 Doe',rand(10000).to_s + '@mail.com', [profile], nil)

    response = transaction.create_customer_profile(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successfully created a customer profile with id:  #{response.customerProfileId}"
        puts "Customer Payment Profile Id List:"
        response.customerPaymentProfileIdList.numericString.each do |id|
          puts id
        end
        puts "Customer Shipping Address Id List:"
        response.customerShippingAddressIdList.numericString.each do |id|
          puts id
        end
      else
        puts "Transaction Failed"
        puts response.messages.messages[0].text
        raise "Failed to create a new customer profile."
      end
    else
      puts "Transaction Failed"
    end
    return response
  end

if __FILE__ == $0
  create_customer_profile_with_accept()
end

