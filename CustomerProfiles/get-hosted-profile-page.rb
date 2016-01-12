require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  def get_hosted_profile_page(customerProfileId = '37696245')
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

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
      puts "#{response.messages.messages[0].code}"
      puts "#{response.messages.messages[0].text}"
      puts "#{response.token}"
    else
      puts "#{response.messages.messages[0].code}"
      puts "#{response.messages.messages[0].text}"
      raise "Failed to get hosted profile page with customer profile id #{request.customerProfileId}"
    end
    return response
  end
  
if __FILE__ == $0
  get_hosted_profile_page()
end
