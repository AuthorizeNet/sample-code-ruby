require 'rubygems'
  require 'yaml'
  require 'authorizenet' 

 require 'securerandom'

  include AuthorizeNet::API

  def get_hosted_payment_page()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    transactionRequest = TransactionRequestType.new
    transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    transactionRequest.payment = PaymentType.new
    transactionRequest.payment.creditCard = CreditCardType.new('4242424242424242','0220','123') 
    transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    
    setting = SettingType.new
    setting.settingName = SettingNameEnum::HostedPaymentReturnOptions
    setting.settingValue = "https://returnurl.com/return/"
    
    settings = Settings.new([setting])
    
    request = GetHostedPaymentPageRequest.new
    request.transactionRequest = transactionRequest
    request.hostedPaymentSettings = settings
    
    response = transaction.get_hosted_payment_page(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "#{response.messages.messages[0].code}"
      puts "#{response.messages.messages[0].text}"
      puts "#{response.token}"
    else
      puts "#{response.messages.messages[0].code}"
      puts "#{response.messages.messages[0].text}"
      raise "Failed to get hosted payment page"
    end
    return response
  end
  
if __FILE__ == $0
  get_hosted_payment_page()
end
