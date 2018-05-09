require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_accept_customer_profile_page(customerProfileId = '37696245')
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    setting = SettingType.new
    setting.settingName = SettingNameEnum::HostedProfileReturnUrl
    setting.settingValue = "https://returnurl.com/return/"
    
    settings = Settings.new([setting])
    
    
    request = GetHostedProfilePageRequest.new
    request.customerProfileId = customerProfileId
    request.refId = ""
    request.hostedProfileSettings = settings
    
    response = transaction.get_hosted_profile_page(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully got Accept Customer page token."
      logger.info "  Response code: #{response.messages.messages[0].code}"
      logger.info "  Response message: #{response.messages.messages[0].text}"
      logger.info "  Token: #{response.token}"
    else
      logger.info "#{response.messages.messages[0].code}"
      logger.info "#{response.messages.messages[0].text}"
      raise "Failed to get hosted profile page with customer profile ID #{request.customerProfileId}"
    end
    return response
  end
  
if __FILE__ == $0
  get_accept_customer_profile_page()
end
