require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
  request = ARBGetSubscriptionRequest.new

  request.refId = 'Sample'
  request.subscriptionId = '2930242'
   
  response = transaction.arb_get_subscription_request(request)
  
  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successful got ARB subscription"
    puts response.messages.messages[0].code
    puts response.messages.messages[0].text
    puts "Subscription name = #{response.subscription.name}"
    puts "Payment schedule start date = #{response.subscription.paymentSchedule.startDate}"
    puts "Payment schedule Total Occurrences = #{response.subscription.paymentSchedule.totalOccurrences}"
    puts "Subscription amount = #{response.subscription.amount}"
    puts "Subscription profile description = #{response.subscription.profile.description}"
    puts "First Name in Billing Address = #{response.subscription.profile.paymentProfile.billTo.firstName}"
   
  else
    puts response.messages.messages[0].code
    puts response.messages.messages[0].text
    raise "Failed to get ARB subscription"
  end
