require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API
  
  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
  puts "PayPal Authorization Capture-Continue Transaction"

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  payPalType = PayPalType.new
  payPalType.successUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
  payPalType.cancelUrl = "http://www.merchanteCommerceSite.com/Success/TC25262"
  payPalType.payerID = "M8R9JRNJ3R28Y"
  
  paymentType = PaymentType.new
  paymentType.payPal = payPalType
      
  request = CreateTransactionRequest.new
  request.transactionRequest = TransactionRequestType.new()
  request.transactionRequest.refTransId = "2241762169"
  request.transactionRequest.amount = 15.00
  request.transactionRequest.payment = paymentType
  request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureContinueTransaction
  
  response = transaction.create_transaction(request)

  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully created an Authorization Capture-Continue transaction (authorization code: #{response.transactionResponse.authCode})"
  else
    puts response.messages.messages[0].text
    puts response.transactionResponse.errors.errors[0].errorCode
    puts response.transactionResponse.errors.errors[0].errorText
    raise "Failed to make purchase."
  end