require 'rubygems'
require 'yaml'
require 'authorizenet' 
require 'securerandom'
require_relative '../shared_helper'

  include AuthorizeNet::API

  def get_customer_payment_profile_list()
    transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
    
    searchTypeEnum = CustomerPaymentProfileSearchTypeEnum::CardsExpiringInMonth
    sorting = CustomerPaymentProfileSorting.new
    orderByEnum = CustomerPaymentProfileOrderFieldEnum::Id
    sorting.orderBy = orderByEnum
    sorting.orderDescending = false
    
    paging = Paging.new
    paging.limit = 1000
    paging.offset = 1
    
    
    request = GetCustomerPaymentProfileListRequest.new

    request.searchType = searchTypeEnum
    request.month = "2020-12"
    request.sorting = sorting
    request.paging = paging
    
    response = transaction.get_customer_payment_profile_list(request)
    
    if response.messages.resultCode == MessageTypeEnum::Ok
      logger.info "Successfully got customer payment profile list."
      logger.info response.messages.messages[0].code
      logger.info response.messages.messages[0].text
      logger.info "  Total number in result set: #{response.totalNumInResultSet}"
#      response.paymentProfiles.paymentProfile.each do |paymentProfile|
#        logger.info "Payment profile ID = #{paymentProfile.customerPaymentProfileId}"
#        logger.info "First Name in Billing Address = #{paymentProfile.billTo.firstName}"
#        logger.info "Credit Card Number = #{paymentProfile.payment.creditCard.cardNumber}"
#      end
    else
      logger.error response.messages.messages[0].code
      logger.error response.messages.messages[0].text
      raise "Failed to get customer payment profile list"
    end
    return response
  end

if __FILE__ == $0
  get_customer_payment_profile_list()
end

