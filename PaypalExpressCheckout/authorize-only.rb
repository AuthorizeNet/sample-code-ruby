require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['paypal_api_login_id'], config['paypal_api_transaction_key'], :gateway => :sandbox)

  request = CreateTransactionRequest.new

  request.transactionRequest = TransactionRequestType.new()
  request.transactionRequest.amount = 5.00
  request.transactionRequest.payment = PaymentType.new
  request.transactionRequest.payment.payPal = PayPalType.new(succesUrl="http://www.merchanteCommerceSite.com/Success/TC25262", cancelUrl="http://www.merchanteCommerceSite.com/Success/TC25262")
  request.transactionRequest.transactionType = TransactionTypeEnum::AuthOnlyTransaction
  
  response = transaction.create_transaction(request)

  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully created a AuthorizeOnly transaction (authorization code: #{response.transactionResponse.authCode})"

  else
    puts response.messages.messages[0].text
    puts response.transactionResponse.errors.errors[0].errorCode
    puts response.transactionResponse.errors.errors[0].errorText
    raise "Failed to make purchase."
  end