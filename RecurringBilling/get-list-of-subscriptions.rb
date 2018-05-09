require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_list_of_subscriptions()
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    request = ARBGetSubscriptionListRequest.new
    request.refId = '2238251168'
    
    request.searchType = ARBGetSubscriptionListSearchTypeEnum::SubscriptionActive
    request.sorting = ARBGetSubscriptionListSorting.new
    request.sorting.orderBy = 'id'
    request.sorting.orderDescending = 'false'
    
    request.paging = Paging.new
    # Paging limit can be up to 1000
    request.paging.limit = '20'
    request.paging.offset = '1'
  
  
    response = transaction.get_subscription_list(request)
    
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        logger.info "Successfully got the list of subscriptions."
        logger.info "  Response code: #{response.messages.messages[0].code}"
        logger.info "  Response message: #{response.messages.messages[0].text}"

        response.subscriptionDetails.subscriptionDetail.each do |sub|
          logger.info "  Subscription #{sub.id} #{sub.name} - Status: #{sub.status}"
          
        end
    
      else
    
        logger.error response.messages.messages[0].code
        logger.error response.messages.messages[0].text
        raise "Failed to get the list of subscriptions."
      end
    end
    return response
  end

if __FILE__ == $0
  get_list_of_subscriptions()
end
