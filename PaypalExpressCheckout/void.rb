require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['paypal_api_login_id'], config['paypal_api_transaction_key'], :gateway => :sandbox)

  request = CreateTransactionRequest.new

  request.transactionRequest = TransactionRequestType.new()
  request.transactionRequest.amount = 16.00
  request.transactionRequest.payment = PaymentType.new
  request.transactionRequest.payment.creditCard = CreditCardType.new('4242424242424242','0220','123') 
  request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
  
  response = transaction.create_transaction(request)

  authTransId = 0

  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successful AuthCapture Transaction (authorization code: #{response.transactionResponse.authCode})"
    authTransId = response.transactionResponse.transId
    puts "Transaction ID (for later void: #{authTransId})"

  else
    puts response.messages.messages[0].text
    puts response.transactionResponse.errors.errors[0].errorCode
    puts response.transactionResponse.errors.errors[0].errorText
    raise "Failed to authorize card."
  end

  request = CreateTransactionRequest.new

  request.transactionRequest = TransactionRequestType.new()
  request.transactionRequest.refTransId = authTransId
  request.transactionRequest.payment = PaymentType.new
  request.transactionRequest.payment.payPal = PayPalType.new(succesUrl="", cancelUrl="")
  request.transactionRequest.transactionType = TransactionTypeEnum::VoidTransaction
  
  response = transaction.create_transaction(request)

  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully voided the transaction (Transaction ID: #{response.transactionResponse.transId})"

  else
    puts response.messages.messages[0].text
    puts response.transactionResponse.errors.errors[0].errorCode
    puts response.transactionResponse.errors.errors[0].errorText
    raise "Failed to void the transaction."
  end