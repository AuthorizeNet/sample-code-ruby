  require 'rubygems'
  require 'yaml'
  require 'authorizenet' 

 require 'securerandom'

  include AuthorizeNet::API

  def create_an_accept_transaction()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

    request = CreateTransactionRequest.new
    request.transactionRequest = TransactionRequestType.new(
      :amount => 39.55,
      :payment => PaymentType.new(:opaqueData => OpaqueDataType.new('COMMON.APPLE.INAPP.PAYMENT','9471471570959063005001') )
  )

    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction

    response = transaction.create_transaction(request)

    if response.messages.resultCode == MessageTypeEnum::Ok
      if response.transactionResponse.responseCode == "1"
        puts "Successfully made a purchase (authorization code: #{response.transactionResponse.authCode})"
      else
        puts "Transaction error code : #{response.transactionResponse.errors.errors[0].errorCode}"
        puts "Transaction error message : #{response.transactionResponse.errors.errors[0].errorText}"
        raise "Failed to make purchase."
      end
    else
      puts "Error code : #{response.messages.messages[0].code}"
      puts "Error message : #{response.messages.messages[0].text}"
      if response.transactionResponse != nil
        puts "Transaction error code : #{response.transactionResponse.errors.errors[0].errorCode}"
        puts "Transaction error message : #{response.transactionResponse.errors.errors[0].errorText}"
      end
      raise "Failed to make purchase."
    end

    return response
  end
  
if __FILE__ == $0
  create_an_accept_transaction()
end
