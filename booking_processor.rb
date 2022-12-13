# frozen_string_literal: true

require_relative 'booking_processor_error'

class BookingProcessor
  def initialize(params)
    @params = params
  end

  def call
    return true if successful_booking?

    raise BookingProcessorError, 'Supplier fail'
  end

  private

  def successful_booking?
    case @params[:booking_supplier]
    when 'booking.com'
      make_booking_com_booking
    when 'agoda.com'
      make_agoda_booking
    when 'expedia.com'
      make_expedia_booking
    else
      raise BookingProcessorError, 'Invalid supplier'
    end
  end

  def make_booking_com_booking
    @params[:room_code] =~ /^1BKG/
  end

  def make_agoda_booking
    @params[:room_code] =~ /^1AGD/
  end

  def make_expedia_booking
    @params[:room_code] =~ /^1EXP/
  end
end
