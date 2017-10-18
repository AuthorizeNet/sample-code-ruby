require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def create_Subscription()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    #subscription = Subscription.new(config['api_login_id'], config['api_subscription_key'], :gateway => :sandbox)
  
    request = ARBCreateSubscriptionRequest.new
    request.refId = DateTime.now.to_s[-8]
    request.subscription = ARBSubscriptionType.new
    request.subscription.name = "Jane Doe"
    request.subscription.paymentSchedule = PaymentScheduleType.new
    request.subscription.paymentSchedule.interval = PaymentScheduleType::Interval.new("3","months")
    request.subscription.paymentSchedule.startDate = (DateTime.now).to_s[0...10]
    request.subscription.paymentSchedule.totalOccurrences ='12'
    request.subscription.paymentSchedule.trialOccurrences ='1'

    random_amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.subscription.amount = random_amount
    request.subscription.trialAmount = 0.00
    request.subscription.payment = PaymentType.new
    request.subscription.payment.creditCard = CreditCardType.new('4111111111111111','0120','123')

    request.subscription.order = OrderType.new('invoiceNumber123','description123')
    request.subscription.customer = CustomerType.new(CustomerTypeEnum::Individual,'custId1','a@a.com')
    request.subscription.billTo = NameAndAddressType.new('John','Doe','xyt','10800 Blue St','New York','NY','10010','USA')
    request.subscription.shipTo = NameAndAddressType.new('John','Doe','xyt','10800 Blue St','New York','NY','10010','USA')

    response = transaction.create_subscription(request)
     
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successfully created a subscription with ID #{response.subscriptionId}."
    
      else
        #puts response.transactionResponse.errors.errors[0].errorCode
        #puts response.transactionResponse.errors.errors[0].errorText
        puts response.messages.messages[0].code
        puts response.messages.messages[0].text
        raise "Failed to create a subscription."
      end
    end
    return response
  end

if __FILE__ == $0
  create_Subscription()
end
