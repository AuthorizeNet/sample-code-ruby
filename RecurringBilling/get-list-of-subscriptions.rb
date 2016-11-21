require 'rubygems'
  require 'yaml'
  require 'authorizenet' 
 require 'securerandom'

  include AuthorizeNet::API

  def get_list_of_subscriptions()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    request = ARBGetSubscriptionListRequest.new
    request.refId = '2238251168'
    
    request.searchType = ARBGetSubscriptionListSearchTypeEnum::SubscriptionActive
    request.sorting = ARBGetSubscriptionListSorting.new
    request.sorting.orderBy = 'id'
    request.sorting.orderDescending = 'false'
    
    request.paging = Paging.new
    request.paging.limit = '1000'
    request.paging.offset = '1'
  
  
    response = transaction.get_subscription_list(request)
    
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Successfully got the list of subscriptions"
        puts response.messages.messages[0].code
        puts response.messages.messages[0].text
    
      else
    
        puts response.messages.messages[0].code
        puts response.messages.messages[0].text
        raise "Failed to get the list of subscriptions"
      end
    end
    return response
 end

if __FILE__ == $0
  get_list_of_subscriptions()
end
