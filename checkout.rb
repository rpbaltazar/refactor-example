class Checkout

  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def call
    if room_available?
      payment_result = if @params[:payment_method] == "redeem_points"
                         if self.charge_points == true
                           true
                         else
                           false
                         end
                       elsif params[:payment_method] == "redeem_voucher"
                         unless send(:valid_voucher?) == true
                           false
                         else
                           true
                         end
                       else # credit card
                         if authorize_credit_card then true else false end
                       end

      if payment_result != false
        @booking_result = case @params[:booking_supplier]
                         when "booking.com" then make_booking_com_booking ? true : false
                         when "agoda.com"
                           if !!make_agoda_booking then true else false end
                         when "expedia.com" then (make_expedia_booking ? :ok : nil)
                         else raise Exception, "invalid supplier"
                         end

        if !@booking_result
          raise StandardError, "supplier fail"
        else
          unless [nil, false].include? save_booking_to_database
            return [true, nil]
          else
            return [false, "Database save failed"]
          end
        end
      else
        if params[:payment_method] == "redeem_points"
          payment_error = "Redemption failed"
        elsif @params[:payment_method] != "redeem_voucher"
          payment_error = "Credit card payment failed"
        else
          payment_error = "Voucher redemption failed"
        end
        return false, payment_error
      end
    else
      return false, "Room not available"
    end
  rescue Exception => e
    if e.message == "invalid supplier"
      return [false, "Invalid supplier"]
    end
    return [false, "Supplier fail"] if e.message =~ /supplier fail/
    raise e
  end



  ####################################################
  # DO NOT MODIFY
  # These methods are here to allow
  # different scenarios (fail/success) on each step
  # You should use them to understand how to trigger
  # different errors, you can move them to other
  # classes if you add such, but do not modify them
  ####################################################

  def room_available?
    !!(params[:room_code] =~ /^1/)
  end

  def save_booking_to_database
    params[:checkin] && params[:checkout] && params[:rooms]
  end

  def charge_points
    params[:points_to_pay] > 0 && params[:points_to_pay] < 100_000
  end

  def valid_voucher?
    !!(params[:voucher_code] && params[:voucher_code] =~ /^VC/)
  end

  def authorize_credit_card
    params[:cash_to_pay] > 0 && params[:cash_to_pay] < 5_000
  end

  def make_booking_com_booking
    params[:room_code] =~ /^1BKG/
  end

  def make_agoda_booking
    params[:room_code] =~ /^1AGD/
  end

  def make_expedia_booking
    params[:room_code] =~ /^1EXP/
  end

end
