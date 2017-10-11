require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_merchant_details()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
    
      transaction = AuthorizeNet::API::Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
      
      request = GetMerchantDetailsRequest.new
      
      #standard api call to retrieve response
      response = transaction.get_merchant_details(request)
      
      if response.messages.resultCode == MessageTypeEnum::Ok
        puts "Get Merchant Details Successful " 
        puts "Gateway Id:   #{response.gatewayId}"
        puts "Merchant Name:   #{response.merchantName}"
        response.processors.processor.each do |processor|
          puts "Processor Name: #{processor.name}"
        end
        response.marketTypes.each do |marketType|
          puts "MarketType: #{marketType}"
        end
        response.productCodes.each do |productCode|
          puts "Product Code: #{productCode}"
        end
        response.paymentMethods.each do |paymentMethod|
          puts "Payment Method: #{paymentMethod}"
        end
        response.currencies.each do |currency|
          puts "Currency: #{currency}"
        end

      else
        puts response.messages.messages[0].code
        puts response.messages.messages[0].text
        raise "Failed to get transaction Details."
      end
    
    return response
  end
  
  
if __FILE__ == $0
  get_merchant_details()
end