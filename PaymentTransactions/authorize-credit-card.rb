require "rubygems"
  require "yaml"
  require "authorizenet" 

 require "securerandom"

  include AuthorizeNet::API

  def authorize_credit_card()
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
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthOnlyTransaction

    userFieldArr = Array.new
    userField = UserField.new("userFieldName","userFieldvalue")
    userFieldArr.push(userField)
    userField = UserField.new("userFieldName1","userFieldvalue1")
    userFieldArr.push(userField)

    request.transactionRequest.userFields = UserFields.new(userFieldArr)

    lineItemArr = Array.new
    lineItem = LineItemType.new("SampleItemId","SampleName","SampleDescription","1","10.00","true")
    lineItemArr.push(lineItem)

    request.transactionRequest.lineItems = LineItems.new(lineItemArr)

    response = transaction.create_transaction(request)
    
    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          puts "Successfully created an AuthOnly Transaction (authorization code: #{response.transactionResponse.authCode})"
          puts "Transaction ID : #{response.transactionResponse.transId}"
          puts "Transaction Response Code : #{response.transactionResponse.responseCode}"
          puts "Code : #{response.transactionResponse.messages.messages[0].code}"
		      puts "Description : #{response.transactionResponse.messages.messages[0].description}"
          puts "User Fields : "
          response.transactionResponse.userFields.userFields.each do |userField|
            puts userField.value
          end
        else
          puts "Transaction Failed" 
          if response.transactionResponse.errors != nil
            puts "Error Code : #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message : #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to authorize card."
        end
      else
        puts "Transaction Failed"
        if response.transactionResponse != nil && response.transactionResponse.errors != nil
          puts "Error Code : #{response.transactionResponse.errors.errors[0].errorCode}"
          puts "Error Message : #{response.transactionResponse.errors.errors[0].errorText}"
        else
          puts "Error Code : #{response.messages.messages[0].code}"
          puts "Error Message : #{response.messages.messages[0].text}"
        end
        raise "Failed to authorize card."
      end
    else
      puts "Response is null"
      raise "Failed to authorize card."
    end

    return response
  end
  
if __FILE__ == $0
  authorize_credit_card()
end