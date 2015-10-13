  require 'rubygems'
  require 'yaml'
  require 'authorizenet'
  
  include AuthorizeNet::API
  
  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
  batchId = "4532808"
  request = GetBatchStatisticsRequest.new
  request.batchId = batchId
  
  #standard api call to retrieve response
  response = transaction.get_batch_statistics(request)
  
  
if response != nil
  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully got the list of subscriptions"
    puts response.messages.messages[0].code
    puts response.messages.messages[0].text
    puts response.batch.batchId
    puts response.batch.settlementTimeUTC
    puts response.batch.settlementTimeLocal
    puts response.batch.settlementState
    puts response.batch.paymentMethod
    for i in 0..response.batch.statistics.length-1
      puts "Statistic Details::"
      puts "Account Type: " + response.batch.statistics[i].accountType
      puts "Charge Amount: " + response.batch.statistics[i].chargeAmount
      puts "Charge Count: " + response.batch.statistics[i].chargeCount
      puts "Refund Amount: " + response.batch.statistics[i].refundAmount
      puts "Refund Count: " + response.batch.statistics[i].refundCount
      puts "Void Count: " + response.batch.statistics[i].voidCount
      puts "Decline Count: " + response.batch.statistics[i].declineCount
      puts "Error Count: " + response.batch.statistics[i].errorCount
    end
    

  else

    puts response.messages.messages[0].code
    puts response.messages.messages[0].text
    raise "Failed to get the batch statistics"
  end
end