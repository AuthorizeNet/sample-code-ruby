require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_customer_profile_ids()
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = GetCustomerProfileIdsRequest.new

    response = transaction.get_customer_profile_ids(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully retrieved customer IDs."
      logger.info "  Number of IDs returned: #{response.ids.numericString.count}"
      # There's no paging options in this API request; the full list is returned every call.
      # If the result set is going to be large, for this sample we'll break it down into smaller
      # chunks so that we don't put 72,000 lines into a log file
      logger.info "  First 20 results:"
      for profileId in 0..19 do
        logger.info "    #{response.ids.numericString[profileId]}"
      end
      # If we wanted to just return the whole list, we'd do something like this:
      #  
      # response.ids.numericString.each do |id|
      #   logger.info id
      # end

    else
      logger.error response.messages.messages[0].text
      raise "Failed to get customer IDs."
    end
    return response
  end
  
  
if __FILE__ == $0
  get_customer_profile_ids()
end
