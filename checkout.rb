require_relative 'checkout_error'
require_relative 'payment_processor'
require_relative 'booking_processor'

class Checkout

  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def call
    validate_params!
    check_room_availability!
    process_payment!
    make_booking!
    [true, nil]
  rescue CheckoutError => e
    [false, e.message]
  end

  private

  def validate_params!
    # NOTE: This method name is inconsistent with what it is actually checking for.
    return true if save_booking_to_database

    # NOTE: The error message is based on the method name as well
    raise CheckoutError, 'Database save failed'
  end

  def check_room_availability!
    return true if room_available?

    raise CheckoutError, 'Room not available'
  end

  def process_payment!
    PaymentProcessor.new(@params).call
  rescue PaymentProcessorError => e
    raise CheckoutError, e.message
  end

  def make_booking!
    BookingProcessor.new(@params).call
  rescue BookingProcessorError => e
    raise CheckoutError, e.message
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
end
