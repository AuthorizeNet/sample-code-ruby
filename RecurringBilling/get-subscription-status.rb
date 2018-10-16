require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_subscription_status(subscriptionId = '4792732')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    #subscription = Subscription.new(config['api_login_id'], config['api_subscription_key'], :gateway => :sandbox)
  
    request = ARBGetSubscriptionStatusRequest.new
    request.refId = '2238251168'
    request.subscriptionId = subscriptionId
  
    response = transaction.get_subscription_status(request)
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successfully got subscription status."
        puts "  Status: #{response.status}"
    
      else
        puts response.messages.messages[0].code
        puts response.messages.messages[0].text
        raise "Failed to get a subscriptions status"
      end
    end
    
    return response
  end

if __FILE__ == $0
  get_subscription_status()
end
