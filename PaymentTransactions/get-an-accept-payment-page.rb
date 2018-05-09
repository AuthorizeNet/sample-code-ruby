require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_an_accept_payment_page()
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    transactionRequest = TransactionRequestType.new
    transactionRequest.amount = 12.12
    transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    
    setting1 = SettingType.new
    setting1.settingName = SettingNameEnum::HostedPaymentButtonOptions
    setting1.settingValue = "{\"text\": \"Pay\"}"

    setting2 = SettingType.new
    setting2.settingName = SettingNameEnum::HostedPaymentOrderOptions
    setting2.settingValue = "{\"show\": false}"
    
    settings = Settings.new([ setting1, setting2])
    
    request = GetHostedPaymentPageRequest.new
    request.transactionRequest = transactionRequest
    request.hostedPaymentSettings = settings
    
    response = transaction.get_hosted_payment_page(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "#{response.messages.messages[0].code}"
      logger.info "#{response.messages.messages[0].text}"
      logger.info "#{response.token}"
    else
      logger.info "#{response.messages.messages[0].code}"
      logger.info "#{response.messages.messages[0].text}"
      raise "Failed to get hosted payment page"
    end
    return response
  end
  
if __FILE__ == $0
  get_an_accept_payment_page()
end
