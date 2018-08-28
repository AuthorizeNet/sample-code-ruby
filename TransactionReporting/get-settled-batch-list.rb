require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require "date"
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_settled_batch_List()
    transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    firstSettlementDate = DateTime.now()-(1 * 7)
    lastSettlementDate = DateTime.now()
  
    logger.info "First settlement date: #{firstSettlementDate} Last settlement date: #{lastSettlementDate}"
    
    request = GetSettledBatchListRequest.new
    request.firstSettlementDate = firstSettlementDate
    request.lastSettlementDate = lastSettlementDate
    request.includeStatistics = true
  
    response = transaction.get_settled_batch_list(request)
      
    if response.messages.resultCode == MessageTypeEnum::Ok
      
      response.batchList.batch.each do |batch|
        logger.info "Transaction Id: #{batch.batchId}"
        logger.info "Settlement Date: #{batch.settlementTimeUTC}"
        logger.info "State: #{batch.settlementState}"
        logger.info "Account Type: #{batch.statistics[0].accountType}"
        logger.info ""
      end
    else
        logger.error response.messages.messages[0].code
        logger.error response.messages.messages[0].text
      raise "Failed to fetch settled batch list"
    end
    
    return response
  
  end

  
  
if __FILE__ == $0
  get_settled_batch_List()
end