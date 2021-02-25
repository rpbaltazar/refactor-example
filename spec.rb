require_relative './checkout'

describe Checkout do

  let(:params) { {
    payment_method: payment_method,
    booking_supplier: booking_supplier,
    room_code: room_code,
    points_to_pay: points_to_pay,
    cash_to_pay: cash_to_pay,
    voucher_code: voucher_code
  }.merge(booking_data) }

  let(:booking_data) { {
    checkin: "2018-05-21",
    checkout: "2018-05-22", rooms: 1
  } }

  let(:points_to_pay) { nil }
  let(:voucher_code) { nil }
  let(:cash_to_pay) { nil }

  let(:service) { Checkout.new(params) }

  shared_examples_for "success" do
    it "returns true and no error" do
      expect(service.call()).to eq [true, nil]
    end
  end

  shared_examples_for "db_failure" do
    it "returns database failure" do
      expect(service.call()).to eq [false, "Database save failed"]
    end
  end

  shared_examples_for "supplier_failure" do
    it "returns supplier failure" do
      expect(service.call()).to eq [false, "Supplier fail"]
    end
  end

  shared_examples_for "redemption_failure" do
    it "returns redemption failure" do
      expect(service.call()).to eq [false, "Redemption failed"]
    end
  end

  shared_examples_for "credit_card_failure" do
    it "returns redemption failure" do
      expect(service.call()).to eq [false, "Credit card payment failed"]
    end
  end

  shared_examples_for "voucher_failure" do
    it "returns voucher failure" do
      expect(service.call()).to eq [false, "Voucher redemption failed"]
    end
  end

  shared_examples_for "invalid_supplier" do
    it "returns invalid supplier failure" do
      expect(service.call()).to eq [false, "Invalid supplier"]
    end
  end

  context "room is available" do

    context "points payment" do
      let(:payment_method) { "redeem_points" }
      let(:points_to_pay) { 5_000 }

      context "supplier is booking.com" do
        let(:booking_supplier) { "booking.com" }
        let(:room_code) { "1BKGCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:points_to_pay) { 5_000_000 }
          it_behaves_like "redemption_failure"
        end
      end

      context "supplier is agoda.com" do
        let(:booking_supplier) { "agoda.com" }
        let(:room_code) { "1AGDCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:points_to_pay) { 5_000_000 }
          it_behaves_like "redemption_failure"
        end
      end

      context "supplier is expedia.com" do
        let(:booking_supplier) { "expedia.com" }
        let(:room_code) { "1EXPCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:points_to_pay) { 5_000_000 }
          it_behaves_like "redemption_failure"
        end
      end

      context "supplier is invalid" do
        let(:booking_supplier) { "nonexisting.com" }
        let(:room_code) { "1FAKECODE" }

        context "payment succeeds" do
          it_behaves_like "invalid_supplier"
        end

        context "payment fails" do
          let(:points_to_pay) { 5_000_000 }
          it_behaves_like "redemption_failure"
        end
      end
    end

    context "voucher payment" do
      let(:payment_method) { "redeem_voucher" }
      let(:voucher_code) { "VCREALCODE" }

      context "supplier is booking.com" do
        let(:booking_supplier) { "booking.com" }
        let(:room_code) { "1BKGCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:voucher_code) { "INVALID" }
          it_behaves_like "voucher_failure"
        end
      end

      context "supplier is agoda.com" do
        let(:booking_supplier) { "agoda.com" }
        let(:room_code) { "1AGDCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:voucher_code) { "INVALID" }
          it_behaves_like "voucher_failure"
        end
      end

      context "supplier is expedia.com" do
        let(:booking_supplier) { "expedia.com" }
        let(:room_code) { "1EXPCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:voucher_code) { "INVALID" }
          it_behaves_like "voucher_failure"
        end
      end

      context "supplier is invalid" do
        let(:booking_supplier) { "nonexisting.com" }
        let(:room_code) { "1FAKECODE" }

        context "payment succeeds" do
          it_behaves_like "invalid_supplier"
        end

        context "payment fails" do
          let(:voucher_code) { "INVALID" }
          it_behaves_like "voucher_failure"
        end
      end
    end

    context "credit card payment" do
      let(:payment_method) { "credit_card" }
      let(:cash_to_pay) { 1_000 }

      context "supplier is booking.com" do
        let(:booking_supplier) { "booking.com" }
        let(:room_code) { "1BKGCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:cash_to_pay) { 500_000 }
          it_behaves_like "credit_card_failure"
        end
      end

      context "supplier is agoda.com" do
        let(:booking_supplier) { "agoda.com" }
        let(:room_code) { "1AGDCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:cash_to_pay) { 500_000 }
          it_behaves_like "credit_card_failure"
        end
      end

      context "supplier is expedia.com" do
        let(:booking_supplier) { "expedia.com" }
        let(:room_code) { "1EXPCODE" }

        context "payment succeeds, booking.com booking succeeds, database save succeeds" do
          it_behaves_like "success"
        end

        context "payment succeeds, booking.com booking succeeds, database save fails" do
          let(:booking_data) { {} }
          it_behaves_like "db_failure"
        end

        context "payment succeeds, booking.com booking fails" do
          let(:room_code) { "1INVALID" }
          it_behaves_like "supplier_failure"
        end

        context "payment fails" do
          let(:cash_to_pay) { 500_000 }
          it_behaves_like "credit_card_failure"
        end
      end

      context "supplier is invalid" do
        let(:booking_supplier) { "nonexisting.com" }
        let(:room_code) { "1FAKECODE" }

        context "payment succeeds" do
          it_behaves_like "invalid_supplier"
        end

        context "payment fails" do
          let(:cash_to_pay) { 500_000 }
          it_behaves_like "credit_card_failure"
        end
      end
    end
  end

  context "room is not available" do
    let(:room_code) { "NOROOMSORRY" }
    let(:payment_method) { "redeem_points" }
    let(:booking_supplier) { "booking.com" }

    it "returns room not available failure" do
      expect(service.call()).to eq [false, "Room not available"]
    end
  end
end
