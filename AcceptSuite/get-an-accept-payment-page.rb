require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_an_accept_payment_page()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    transactionRequest = TransactionRequestType.new
    transactionRequest.amount = 12.12
    transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    
    setting1=SettingType.new(settingName = SettingNameEnum::HostedPaymentButtonOptions, settingValue = "{\"text\": \"Pay\"}")
    setting2=SettingType.new(settingName = SettingNameEnum::HostedPaymentOrderOptions, settingValue =  "{\"show\": false}")
    
    settings = Settings.new([ setting1, setting2])
    
    request = GetHostedPaymentPageRequest.new
    request.transactionRequest = transactionRequest
    request.hostedPaymentSettings = settings
    
    response = transaction.get_hosted_payment_page(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "#{response.messages.message[0].code}"
      puts "#{response.messages.message[0].text}"
      puts "#{response.token}"
    else
      puts "#{response.messages.message[0].code}"
      puts "#{response.messages.message[0].text}"
      raise "Failed to get hosted payment page"
    end
    return response
  end
  
if __FILE__ == $0
  get_an_accept_payment_page()
end
