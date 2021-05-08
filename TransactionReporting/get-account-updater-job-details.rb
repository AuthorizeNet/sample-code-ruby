require 'rubygems'
require 'yaml'
require 'authorizenet'
require 'securerandom'
require 'certified'


  include AuthorizeNet::API
 
 
  def get_account_updater_job_Details()
   config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
   transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
   modifiedTypeFilter = "all"
     refId = '123456'
     paging = Paging.new
     paging.limit = 100
     paging.offset = 1
     request = GetAUJobDetailsRequest.new
     request.paging = paging
     request.month = "2018-08"
     request.modifiedTypeFilter = modifiedTypeFilter
     request.refId = refId
     response = transaction.get_aujob_details(request)
     puts response.messages.resultCode
     
     if response != nil
       if response.messages.resultCode == MessageTypeEnum::Ok
         if response.auDetails == nil
           return response;
         else
           puts response.auDetails
           puts "Reference Id Is : #{response.refId}"
           puts "Total Number In Result Set : #{response.totalNumInResultSet}"
           update = response.auDetails[0].auUpdate
           update.each do|update|
             puts "AuUpdate Start"
             puts "Customer Profile ID : #{update.customerProfileID}"
             puts "Customer Payment Profile ID : #{update.customerPaymentProfileID}"
             puts "Update Time (UTC) : #{update.updateTimeUTC}"
             puts "Reason Code : #{update.auReasonCode}"
             puts "Reason Description : #{update.reasonDescription}"
             subscription = update.subscriptionIdList[0].subscriptionId
             if subscription != nil
                puts "Subscription ID list : #{subscription[0]}"
              end   
             puts "New Card Details"
              puts "Card Number : #{update.newCreditCard.cardNumber}"
              puts "New Expiration Date : #{update.newCreditCard.expirationDate}"
              puts "New Card Type : #{update.newCreditCard.cardType}"
              puts "Old Card Details"
              puts "Card Number : #{update.oldCreditCard.cardNumber}"
              puts "Expiration Date : #{update.oldCreditCard.expirationDate}"
              puts "Old Card Type : #{update.oldCreditCard.cardType}"
              puts "AuUpdate End"
            end
            delete =  response.auDetails[0].auDelete
            delete.each do|delete|
              puts "AuDelete Start"
              puts "Customer Profile ID : #{delete.customerProfileID}"
              puts "Customer Payment Profile ID : #{delete.customerPaymentProfileID}"
              puts "Update Time (UTC) : #{delete.updateTimeUTC}"
              puts "Reason Code : #{delete.auReasonCode}"
              puts "Reason Description : #{delete.reasonDescription}"
              subscription = delete.subscriptionIdList[0].subscriptionId
              if subscription != nil
                puts "Subscription ID list : #{subscription[0]}"
              end  
              puts "Credit Card Details"
              puts "Card Number : #{delete.creditCard.cardNumber}"
              puts "Expiration Date : #{delete.creditCard.expirationDate}"
              puts "Card Type : #{delete.creditCard.cardType}"
              puts "AuDelete End"
            end
           
          end
        else
          puts response.messages.messages[0].code        
          puts response.messages.messages[0].text
          
        end
      else
        puts "Response is null"
        
      end

    return response
  end

if __FILE__ == $0
  get_account_updater_job_Details()
end