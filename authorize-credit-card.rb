require 'rubygems'
require 'yaml'
require 'authorizenet'

include AuthorizeNet::API

config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

request = CreateTransactionRequest.new

request.transactionRequest = TransactionRequestType.new()
request.transactionRequest.amount = 28.00
request.transactionRequest.payment = PaymentType.new
request.transactionRequest.payment.creditCard = CreditCardType.new('4007000000027','1220','123')
request.transactionRequest.transactionType = TransactionTypeEnum::AuthOnlyTransaction

response = transaction.create_transaction(request)

if response.messages.resultCode == MessageTypeEnum::Ok
  puts "Success: AuthorizeOnly: #{response.transactionResponse.authCode})"

else
  puts response.messages.messages[0].text
  puts response.transactionResponse.errors.errors[0].errorCode
  puts response.transactionResponse.errors.errors[0].errorText
  raise "Failed to make purchase."
end
