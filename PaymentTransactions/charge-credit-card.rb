require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def charge_credit_card()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config["api_login_id"], config["api_transaction_key"], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new

    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new("4242424242424242","0220","123") 
    request.transactionRequest.customer = CustomerDataType.new(CustomerTypeEnum::Individual,"CUST-1234","bmc@mail.com",DriversLicenseType.new("DrivLicenseNumber123","WA","05/05/1990"),"123456789")
    request.transactionRequest.billTo = CustomerAddressType.new("firstNameBT","lastNameBT","companyBT","addressBT","New York","NY",
          "10010","USA","2121111111","2121111111")
    request.transactionRequest.shipTo = NameAndAddressType.new("firstNameST","lastNameST","companyST","addressST","New York","NY",
          "10010","USA")
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    request.transactionRequest.order = OrderType.new("invoiceNumber#{(SecureRandom.random_number*1000000).round(0)}","Order Description")    
    
    # tax, duty, and shipping are all instances of ExtendedAmountType
    # Arguments for ExtendedAmountType.new are amount, name, description
    request.transactionRequest.tax = ExtendedAmountType.new("0.99","Sales tax","Local municipality sales tax")
    # Or, you can specify the components one at a time:
    request.transactionRequest.shipping = ExtendedAmountType.new
    request.transactionRequest.shipping.amount = "5.20"
    request.transactionRequest.shipping.name = "Shipping charges"
    request.transactionRequest.shipping.description = "Ultra-fast 3 day shipping"

    # Build an array of line items
    lineItemArr = Array.new
    # Arguments for LineItemType.new are itemId, name, description, quanitity, unitPrice, taxable
    lineItem = LineItemType.new("SampleItemId","SampleName","SampleDescription","1","10.00","true")
    lineItemArr.push(lineItem)
    # Or, you can specify the components one at a time:
    lineItem = LineItemType.new
    lineItem.itemId = "1234"
    lineItem.name = "Line Item 2"
    lineItem.description = "another line item"
    lineItem.quantity = "2"
    lineItem.unitPrice = "2.95"
    lineItem.taxable = "false"
    lineItemArr.push(lineItem)
    request.transactionRequest.lineItems = LineItems.new(lineItemArr)

    # Build an array of user fields
    userFieldArr = Array.new
    requestUserField = UserField.new("userFieldName","userFieldvalue")
    userFieldArr.push(requestUserField)
    requestUserField = UserField.new("userFieldName1","userFieldvalue1")
    userFieldArr.push(requestUserField)
    request.transactionRequest.userFields = UserFields.new(userFieldArr)


    response = transaction.create_transaction(request)
  
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode})"
          puts "Transaction ID: #{response.transactionResponse.transId}"
          puts "Transaction Response Code: #{response.transactionResponse.responseCode}"
          puts "Code: #{response.transactionResponse.messages.messages[0].code}"
		      puts "Description: #{response.transactionResponse.messages.messages[0].description}"
          puts "User Fields: "
          response.transactionResponse.userFields.userFields.each do |userField|
            puts userField.value
          end
        else
          puts "Transaction Failed"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to charge card."
        end
      else
        puts "Transaction Failed"
        if response.transactionResponse != nil && response.transactionResponse.errors != nil
          puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
          puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
        else
          puts "Error Code: #{response.messages.messages[0].code}"
          puts "Error Message: #{response.messages.messages[0].text}"
        end
        raise "Failed to charge card."
      end
    else
      puts "Response is null"
      raise "Failed to charge card."
    end
    
    return response
  end
  
if __FILE__ == $0
  charge_credit_card()
end
