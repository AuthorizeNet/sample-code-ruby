require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def get_customer_payment_profile_nonce()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    request = GetCustomerPaymentProfileNonceRequest.new
    request.connectedAccessToken = "eyJraWQiOiI1YWI2NTIxNDBlZGU3ZWZkMDAwMDAwMDA1NGNlOWRhOCIsImFsZyI6IlJTMjU2In0.eyJqdGkiOiIyMGIyYWU1Ni1hZjk4LTQ5OWMtOTczOS04ZDg1MWQ3YjBkMDIiLCJzY29wZXMiOlsicmVhZCIsIndyaXRlIl0sImlhdCI6MTU0MzM5OTYwOTU0NiwiYXNzb2NpYXRlZF9pZCI6IjM3ODciLCJjbGllbnRfaWQiOiJ4ZVFmcFJSSTVYIiwibWVyY2hhbnRfaWQiOiI2NjgzOTQiLCJhZGRpdGlvbmFsSW5mbyI6IntcImFwaUxvZ2luSWRcIjpcIjI1TDdLVmd3NyAgICAgICAgICAgXCIsXCJyb3V0aW5nSWRcIjpcIiQkMjVMN0tWZ3c3JCRcIn0iLCJleHBpcmVzX2luIjoxNTQzNDI4NDA5NTQ4LCJncmFudF90eXBlIjoiYXV0aG9yaXphdGlvbl9jb2RlIiwic29sdXRpb25faWQiOiJBQUExMDI5MjIifQ.JQL3YovrTOuh3UaBGLxP8RNbzGGeJ1Id309lysnMcRJEYDCpv6999A4n6Yznr6uzePjpEwbiyd2osDoGnrP_wQmpLwGPR3eBb3DIOiAhKuAbc1YdpsNa3rd2qbVHPFO95_x2y6r7yRCvgNiRx01GFOXphZ3gPrSuHd93U-h0OLd6nt2GKQQcZ8IQ7f-44fViNgLEH_FTPETKAaooSK8v4XFa7Fh3rYM-jd5snrK4dnp7L2xcLb3JivKwsVXCtLGkNbjXu6DQFtlbzEyVknv9j7GBJgOTvsE_lBqmQaFIdNrYiOf6bH0xAfelgNy_7db77zvSPfvrH9afb5DB_pTl-Q"
    request.customerProfileId = "1504802749"
    request.customerPaymentProfileId = "1504102965"
    
    response = transaction.get_customer_payment_profile_nonce(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      puts "Successfully got customer payment profile nonce."
      puts "Data Descriptor: #{response.opaqueData.dataDescriptor}"
      puts "Data Value: #{response.opaqueData.dataValue}"
      puts "Expiration Time Stamp: #{response.opaqueData.expirationTimeStamp}"

      
    else
      puts "#{response.messages.messages[0].code}"
      puts "#{response.messages.messages[0].text}"
      raise "Failed to get customer payment profile nonce with customer profile ID #{request.customerProfileId}"
    end
    return response
  end
  
if __FILE__ == $0
    get_customer_payment_profile_nonce()
end
