require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  def get_customer_profile_ids()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    
    request = GetCustomerProfileIdsRequest.new

    response = transaction.get_customer_profile_ids(request)


    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully retrieved customer ids:"
      response.ids.numericString.each do |id|
        puts id
      end

    else
      puts response.messages.messages[0].text
      raise "Failed to get customer profile information with id #{request.customerProfileId}"
    end
    return response
  end
  
  
if __FILE__ == $0
  get_customer_profile_ids()
end
