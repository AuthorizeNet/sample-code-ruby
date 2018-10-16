require 'rubygems'
require 'yaml'
require 'authorizenet'
require 'securerandom'

  include AuthorizeNet::API

  def create_customer_profile()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    # Build the payment object
    payment = PaymentType.new(CreditCardType.new)
    payment.creditCard.cardNumber = '4111111111111111'
    payment.creditCard.expirationDate = '2020-05'

    # Build an address object
    billTo = CustomerAddressType.new
    billTo.firstName = "Ellen"
    billTo.lastName = "Johnson"
    billTo.company = "Souveniropolis"
    billTo.address = "14 Main Street"
    billTo.city = "Pecan Springs"
    billTo.state = "TX"
    billTo.zip = "44628"
    billTo.country = "US"
    billTo.phoneNumber = "999-999-9999"
    billTo.faxNumber = "999-999-9999"

    # Use the previously defined payment and billTo objects to
    # build a payment profile to send with the request
    paymentProfile = CustomerPaymentProfileType.new
    paymentProfile.payment = payment
    paymentProfile.billTo = billTo
    paymentProfile.defaultPaymentProfile = true

    # Build a shipping address  to send with the request
    shippingAddress = CustomerAddressType.new
    shippingAddress.firstName = "John"
    shippingAddress.lastName = "Snow"
    shippingAddress.company = "Night's Watch, Inc."
    shippingAddress.address = "Castle Black"
    shippingAddress.city = "The Wall"
    shippingAddress.state = "North Westeros"
    shippingAddress.zip = "99499"
    shippingAddress.country = "Westeros"
    shippingAddress.phoneNumber = "999-999-9999"
    shippingAddress.faxNumber = "999-999-9999"

    # Build the request object
    request = CreateCustomerProfileRequest.new
    # Build the profile object containing the main information about the customer profile
    request.profile = CustomerProfileType.new
    request.profile.merchantCustomerId = 'jdoe' + rand(10000).to_s
    request.profile.description = 'John2 Doe'
    request.profile.email = rand(10000).to_s + '@mail.com'
    # Add the payment profile and shipping profile defined previously
    request.profile.paymentProfiles = [paymentProfile]
    request.profile.shipToList = [shippingAddress]    
    request.validationMode = ValidationModeEnum::LiveMode    

    response = transaction.create_customer_profile(request)
    puts response.messages.resultCode

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successfully created a customer profile with id: #{response.customerProfileId}"
        puts "  Customer Payment Profile Id List:"
        response.customerPaymentProfileIdList.numericString.each do |id|
          puts "    #{id}"
        end
        puts "  Customer Shipping Address Id List:"
        response.customerShippingAddressIdList.numericString.each do |id|
          puts "    #{id}"
        end
        puts 
      else
        puts response.messages.messages[0].code        
        puts response.messages.messages[0].text
        raise "Failed to create a new customer profile."
      end
    else
      puts "Response is null"
      raise "Failed to create a new customer profile."
    end

    return response
  end

  if __FILE__ == $0
    create_customer_profile()
  end
