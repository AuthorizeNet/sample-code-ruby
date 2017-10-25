require 'rubygems'
require 'yaml'
require 'authorizenet'
require 'securerandom'

  include AuthorizeNet::API

  def create_customer_payment_profile(customerProfileId = '1813343337')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    # Build the payment object
    payment = PaymentType.new(CreditCardType.new)
    payment.creditCard.cardNumber = '4111111111111111'
    payment.creditCard.expirationDate = '2022-05'

    # Build an address object
    billTo = CustomerAddressType.new
    billTo.firstName = "Jerry"
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

    # Build the request object
    request = CreateCustomerPaymentProfileRequest.new
    request.paymentProfile = paymentProfile
    request.customerProfileId = customerProfileId
    request.validationMode = ValidationModeEnum::LiveMode        

    response = transaction.create_customer_payment_profile(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successfully created a customer payment profile with id: #{response.customerPaymentProfileId}."
      else
        puts response.messages.messages[0].code        
        puts response.messages.messages[0].text
        puts "Failed to create a new customer payment profile."
      end
    else
      puts "Response is null"
      raise "Failed to create a new customer payment profile."
    end
    return response
  end

if __FILE__ == $0
  create_customer_payment_profile()
end
