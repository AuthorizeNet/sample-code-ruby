require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def update_split_tender_group()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    #set the split tender ID here
    splitTenderId = "115901"
    #set the split tender status here.
    #SplitTenderStatusEnum::Completed
    #SplitTenderStatusEnum::Held
    #SplitTenderStatusEnum::Voided
    splitTenderStatus = SplitTenderStatusEnum::Voided
    
    request = UpdateSplitTenderGroupRequest.new
  
    request.splitTenderId = splitTenderId
    request.splitTenderStatus = splitTenderStatus
    
    response = transaction.update_split_tender_group(request)
  
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successful Update Split Tender Group"
      puts response.messages.messages[0].code
      puts response.messages.messages[0].text
  
    else
      puts response.messages.messages[0].code
      puts response.messages.messages[0].text
      raise "Failed to update split tender group."
    end
    
    return response
  end
  
if __FILE__ == $0
  update_split_tender_group()
end
