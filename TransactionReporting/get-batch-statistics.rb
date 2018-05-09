require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'
  
  include AuthorizeNet::API
  
  def get_batch_Statistics(batchId = "7889547")
    transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    request = GetBatchStatisticsRequest.new
    request.batchId = batchId
    
    #standard api call to retrieve response
    response = transaction.get_batch_statistics(request)
    
    
  if response != nil
    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully got the list of batch statistics."
      logger.info response.messages.messages[0].code
      logger.info response.messages.messages[0].text
      logger.info response.batch.batchId
      logger.info response.batch.settlementTimeUTC
      logger.info response.batch.settlementTimeLocal
      logger.info response.batch.settlementState
      logger.info response.batch.paymentMethod
      for i in 0..response.batch.statistics.length-1
        logger.info "Statistic Details::"
        logger.info "Account Type: " + response.batch.statistics[i].accountType.to_s
        logger.info "Charge Amount: " + response.batch.statistics[i].chargeAmount.to_s
        logger.info "Charge Count: " + response.batch.statistics[i].chargeCount.to_s
        logger.info "Refund Amount: " + response.batch.statistics[i].refundAmount.to_s
        logger.info "Refund Count: " + response.batch.statistics[i].refundCount.to_s
        logger.info "Void Count: " + response.batch.statistics[i].voidCount.to_s
        logger.info "Decline Count: " + response.batch.statistics[i].declineCount.to_s
        logger.info "Error Count: " + response.batch.statistics[i].errorCount.to_s
      end
      
  
    else
  
      logger.error response.messages.messages[0].code
      logger.error response.messages.messages[0].text
      raise "Failed to get the batch statistics"
    end
  end
  
  return response

  end

if __FILE__ == $0
  get_batch_Statistics()
end
