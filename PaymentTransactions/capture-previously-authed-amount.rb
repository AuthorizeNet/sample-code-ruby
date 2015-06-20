require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  request = CreateTransactionRequest.new

  request.transactionRequest = TransactionRequestType.new()
  request.transactionRequest.amount = 30.00
  request.transactionRequest.refTransId = '2235453314'
  request.transactionRequest.payment = PaymentType.new
  request.transactionRequest.payment.creditCard = CreditCardType.new('4007000000027','1220','123')
  #request.transactionRequest.authCode = "0OL8YC"
  request.transactionRequest.order = OrderType.new
  request.transactionRequest.order.invoiceNumber = "INV-12345"
  request.transactionRequest.order.description = "Ruby Test Product Description"
  request.transactionRequest.transactionType = TransactionTypeEnum::PriorAuthCaptureTransaction
  
  response = transaction.create_transaction(request)

  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully created a prior Auth Capture Transaction"

  else
    puts response.messages.messages[0].text
    puts response.transactionResponse.errors.errors[0].errorCode
    puts response.transactionResponse.errors.errors[0].errorText
    raise "Failed to authorize a previously captured amount."
  end