require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def approve_or_decline_held_transaction(refTransId)
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = UpdateHeldTransactionRequest.new
  
    request.heldTransactionRequest = HeldTransactionRequestType.new()
    request.heldTransactionRequest.action = AfdsTransactionEnum::Approve
    request.heldTransactionRequest.refTransId = "60012148061"
    
    response = transaction.update_held_transaction(request)
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          puts "Successfully updated transaction: #{response.transactionResponse.authCode})"
          puts "Transaction Response code: #{response.transactionResponse.responseCode}"
          puts "Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "Description: #{response.transactionResponse.messages.messages[0].description}"
        else
          puts "Update Transaction Failed"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to update transaction."
        end
      else
        puts "Update transaction Failed"
        if response.transactionResponse != nil && response.transactionResponse.errors != nil
          puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
          puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
        else
          puts "Error Code: #{response.messages.messages[0].code}"
          puts "Error Message: #{response.messages.messages[0].text}"
        end
        raise "Failed to update transaction."
      end
    else
      puts "Response is null"
      raise "Failed to update transaction."
    end
    
    return response
  end
  
if __FILE__ == $0
  update_held_transaction("12345")
end
