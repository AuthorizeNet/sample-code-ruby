require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_subscription(subscriptionId = '2930242')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    request = ARBGetSubscriptionRequest.new
  
    request.refId = 'Sample'
    request.subscriptionId = subscriptionId
     
    response = transaction.arb_get_subscription_request(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully got subscription details."
      puts "  Response code: #{response.messages.messages[0].code}"
      puts "  Response message: #{response.messages.messages[0].text}"
      puts "  Subscription name: #{response.subscription.name}"
      puts "  Payment schedule start date: #{response.subscription.paymentSchedule.startDate}"
      puts "  Payment schedule Total Occurrences: #{response.subscription.paymentSchedule.totalOccurrences}"
      puts "  Subscription amount: %.2f " % [response.subscription.amount]
      puts "  Subscription profile description: #{response.subscription.profile.description}"
      puts "  First Name in Billing Address: #{response.subscription.profile.paymentProfile.billTo.firstName}"
     
    else
      puts response.messages.messages[0].code
      puts response.messages.messages[0].text
      raise "Failed to get subscription details."
    end
    
    return response
  end
  
if __FILE__ == $0
  get_subscription()
end
