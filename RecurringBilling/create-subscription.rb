require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  #subscription = Subscription.new(config['api_login_id'], config['api_subscription_key'], :gateway => :sandbox)

    request = ARBCreateSubscriptionRequest.new
    request.refId = '2238251168'
    request.subscription = ARBSubscriptionType.new
    request.subscription.name = "Jane Doe"
    request.subscription.paymentSchedule = PaymentScheduleType.new
    request.subscription.paymentSchedule.interval = PaymentScheduleType::Interval.new("3","months")
    request.subscription.paymentSchedule.startDate = '2017-08-30'
    request.subscription.paymentSchedule.totalOccurrences ='12'
    request.subscription.paymentSchedule.trialOccurrences ='1'

    request.subscription.amount = 0.09
    request.subscription.trialAmount = 0.00
    request.subscription.payment = PaymentType.new
    request.subscription.payment.creditCard = CreditCardType.new('4111111111111111','0120','123')

    request.subscription.order = OrderType.new('invoiceNumber123','description123')
    request.subscription.customer =  CustomerDataType.new(CustomerTypeEnum::Individual,'custId1','a@a.com')
    request.subscription.billTo = NameAndAddressType.new('John','Doe','xyt','10800 Blue St','New York','NY','10010','USA')
    request.subscription.shipTo = NameAndAddressType.new('John','Doe','xyt','10800 Blue St','New York','NY','10010','USA')

     response = transaction.create_subscription(request)
     
    #validate the transaction was created
    #expect(response.transactionResponse.transId).not_to eq("0")  
    #{request.customerProfileId}


if response != nil
  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully created a subscription #{response.subscriptionId}"

  else
    #puts response.transactionResponse.errors.errors[0].errorCode
    #puts response.transactionResponse.errors.errors[0].errorText
    puts response.messages.messages[0].code
    puts response.messages.messages[0].text
    raise "Failed to create a subscription"
  end
end
