require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'

  include AuthorizeNet::API

  def create_chase_pay_transaction()
    config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")
  
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
    request = CreateTransactionRequest.new
  
    request.transactionRequest = TransactionRequestType.new()
    request.transactionRequest.transactionType = TransactionTypeEnum::AuthCaptureTransaction
    request.transactionRequest.amount = ((SecureRandom.random_number + 1 ) * 150 ).round(2)
    request.transactionRequest.payment = PaymentType.new
    request.transactionRequest.payment.creditCard = CreditCardType.new
    request.transactionRequest.payment.creditCard.cardNumber ="4242424242424242"
    request.transactionRequest.payment.creditCard.expirationDate="0728"
    request.transactionRequest.payment.creditCard.cardCode="123"
    request.transactionRequest.payment.creditCard.cryptogram="EjRWeJASNFZ4kBI0VniQEjRWeJA="
    request.transactionRequest.payment.creditCard.tokenRequestorName="CHASE_PAY"
    request.transactionRequest.payment.creditCard.tokenRequestorId="12345678901"
    request.transactionRequest.payment.creditCard.tokenRequestorEci="07"
    request.transactionRequest.order = OrderType.new    
    request.transactionRequest.order.invoiceNumber ="invoiceNumber#{(SecureRandom.random_number*1000000).round(0)}"
    request.transactionRequest.order.description ="Order Description"

    response = transaction.create_transaction(request)

    if response != nil
      if response.messages.resultCode == MessageTypeEnum::Ok
        if response.transactionResponse != nil && response.transactionResponse.messages != nil
          if response.transactionResponse.responseCode == '1'
            puts "Successfully created transaction with Transaction ID: #{response.transactionResponse.transId}"
            puts "Transaction Response code: #{response.transactionResponse.responseCode}"
            puts "Code: #{response.transactionResponse.messages.messages[0].code}"
            puts "Description: #{response.transactionResponse.messages.messages[0].description}"
          else
            puts "Transaction Failed"
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
        else
          puts "Transaction Failed"
          if response.transactionResponse.errors != nil
            puts "Error Code: #{response.transactionResponse.errors.errors[0].errorCode}"
            puts "Error Message: #{response.transactionResponse.errors.errors[0].errorText}"
          end
          raise "Failed to charge tokenized credit card."
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
        raise "Failed to charge tokenized credit card."
      end
    else
      puts "Response is null"
      raise "Failed to charge tokenized credit card."
    end
        
    return response
  end
  
if __FILE__ == $0
  create_chase_pay_transaction()
end