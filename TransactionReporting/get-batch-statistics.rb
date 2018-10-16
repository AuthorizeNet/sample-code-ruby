require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
  
  include AuthorizeNet::API
  
  def get_batch_Statistics(batchId = "7889547")
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    
    transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    request = GetBatchStatisticsRequest.new
    request.batchId = batchId
    
    #standard api call to retrieve response
    response = transaction.get_batch_statistics(request)
    
    
  if response != nil
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully got the list of batch statistics."
      puts response.messages.messages[0].code
      puts response.messages.messages[0].text
      puts response.batch.batchId
      puts response.batch.settlementTimeUTC
      puts response.batch.settlementTimeLocal
      puts response.batch.settlementState
      puts response.batch.paymentMethod
      for i in 0..response.batch.statistics.length-1
        puts "Statistic Details::"
        puts "Account Type: " + response.batch.statistics[i].accountType.to_s
        puts "Charge Amount: " + response.batch.statistics[i].chargeAmount.to_s
        puts "Charge Count: " + response.batch.statistics[i].chargeCount.to_s
        puts "Refund Amount: " + response.batch.statistics[i].refundAmount.to_s
        puts "Refund Count: " + response.batch.statistics[i].refundCount.to_s
        puts "Void Count: " + response.batch.statistics[i].voidCount.to_s
        puts "Decline Count: " + response.batch.statistics[i].declineCount.to_s
        puts "Error Count: " + response.batch.statistics[i].errorCount.to_s
      end
      
  
    else
  
      puts response.messages.messages[0].code
      puts response.messages.messages[0].text
      raise "Failed to get the batch statistics"
    end
  end
  
  return response

  end

if __FILE__ == $0
  get_batch_Statistics()
end
