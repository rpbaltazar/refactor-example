# frozen_string_literal: true

require_relative 'payment_processor_error'

class PaymentProcessor
  def initialize(params)
    @params = params
  end

  def call
    return true if successful_charge?

    payment_error = case @params[:payment_method]
                    when 'redeem_points'
                      'Redemption failed'
                    when 'redeem_voucher'
                      'Voucher redemption failed'
                    else
                      'Credit card payment failed'
                    end

    raise PaymentProcessorError, payment_error
  end

  private

  def successful_charge?
    case @params[:payment_method]
    when 'redeem_points'
      charge_points
    when 'redeem_voucher'
      valid_voucher?
    else # credit card
      authorize_credit_card
    end
  end

  def charge_points
    @params[:points_to_pay] > 0 && @params[:points_to_pay] < 100_000
  end

  def valid_voucher?
    !!(@params[:voucher_code] && @params[:voucher_code] =~ /^VC/)
  end

  def authorize_credit_card
    @params[:cash_to_pay] > 0 && @params[:cash_to_pay] < 5_000
  end
end
