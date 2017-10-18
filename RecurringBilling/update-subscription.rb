require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def update_subscription(subscriptionId = '3095800')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    #subscription = Subscription.new(config['api_login_id'], config['api_subscription_key'], :gateway => :sandbox)
  
    request = ARBUpdateSubscriptionRequest.new
    request.refId = '2238251168'
    request.subscriptionId = subscriptionId
    request.subscription = ARBSubscriptionType.new
    
    request.subscription.payment = PaymentType.new
    request.subscription.payment.creditCard = CreditCardType.new('4111111111111111','0125','123')
  
    response = transaction.update_subscription(request)
     
    # You can pass a customer profile to update subscription
    #request.subscription.profile = CustomerProfileIdType.new
    #request.subscription.profile.customerProfileId = "123213"
    #request.subscription.profile.customerPaymentProfileId = "2132321"
    #request.subscription.profile.customerAddressId = "2131232"

    #validate the transaction was created
    #expect(response.transactionResponse.transId).not_to eq("0")  
    #{request.customerProfileId}
  
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successfully updated a subscription."
        puts "  Response code: #{response.messages.messages[0].code}"
        puts "  Response message: #{response.messages.messages[0].text}"
    
      else
        #puts response.transactionResponse.errors.errors[0].errorCode
        #puts response.transactionResponse.errors.errors[0].errorText
        puts response.messages.messages[0].code
        puts response.messages.messages[0].text
        raise "Failed to get a subscriptions status"
      end
    end
  
    return response
  end

if __FILE__ == $0
  update_subscription()
end
