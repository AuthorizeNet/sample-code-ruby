require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)

  merchantAuthentication = MerchantAuthenticationType.new()
  merchantAuthentication.name = " 556KThWQ6vf2"
  merchantAuthentication.transactionKey = "9ac2932kQ7kN2Wzq"


  LineItem = LineItemType.new
  LineItem.itemId = "Jackets"
  LineItem.name = "L.L. Bean"
  LineItem.description = "Winter Heavy Parka"
  LineItem.quantity = 1.0
  LineItem.unitPrice = 135.40

  Tax = ExtendedAmountType.new
  Tax.amount = 15.00
  Tax.name = "Level 2 Tax"
  Tax.description = "Federal Sales Tax"

  Customer = CustomerDataType.new
  Customer.id = 201
  Customer.email = "rubyonrails@domain.com"

  ShipTo = NameAndAddressType.new
  ShipTo.firstName = "Bayles"
  ShipTo.lastName = "China"
  ShipTo.company = "Tyme for Tea"
  ShipTo.address = "12 Main Street"
  ShipTo.city = "Pecan Spings"
  ShipTo.state = "TX"
  ShipTo.zip = "44628"
  ShipTo.country = "USA"

  BillTo = CustomerAddressType.new
  BillTo.firstName = "Ellen"
  BillTo.lastName = "Johnson"
  BillTo.company = "Souveniropolis"
  BillTo.address = "14 Main Street"
  BillTo.city = "Pecan Spings"
  BillTo.state = "TX"
  BillTo.zip = "44628"
  BillTo.country = "USA"

  Order = OrderType.new
  Order.invoiceNumber = "INV-56789"
  Order.description = "Ruby Test Purchase Order Description"

  PurchaseOrderNumber = 115

  refTransId = 'ref' + Time.now.to_s

  request = CreateTransactionRequest.new

  request.transactionRequest = TransactionRequestType.new()
  request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
  request.transactionRequest.refTransId =  refTransId
  request.transactionRequest.payment = PaymentType.new
  request.transactionRequest.payment.creditCard = CreditCardType.new('4007000000027','1220','123')
  request.transactionRequest.amount = 175.21
  request.transactionRequest.tax = Tax
  request.transactionRequest.poNumber = PurchaseOrderNumber
  request.transactionRequest.customer = Customer
  request.transactionRequest.billTo = BillTo
  request.transactionRequest.shipTo = ShipTo

  response = transaction.create_transaction(request)

  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully Charged a Credit Card"
    puts "Authorization Code " + response.transactionResponse.authCode
    puts "Transaction Id " + response.transactionResponse.transId
    puts "Transaction Hash " + response.transactionResponse.transHash
  else
    puts response.messages.messages[0].text
    puts response.transactionResponse.errors.errors[0].errorCode
    puts response.transactionResponse.errors.errors[0].errorText
    raise "Failed to Charge a Credit Card"
  end