# frozen_string_literal: true

# == Schema Information
#
# Table name: carts
#
#  id            :bigint(8)        not null, primary key
#  duration      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  book_owner_id :bigint(8)        not null
#  user_id       :bigint(8)
#
# Indexes
#
#  index_carts_on_book_owner_id  (book_owner_id)
#  index_carts_on_user_id        (user_id)
#

require 'rails_helper'

RSpec.describe Cart, type: :model do
  it { should belong_to(:user).optional }
  it { should have_many(:items).dependent(:destroy) }
  it { should have_many(:appointments) }
  it { should have_one(:pending_pickup_appointment).conditions(appointment_type: :pickup, state: :pending) }
  it { should validate_presence_of :book_owner_id }
  it { should enumerize(:duration) }

  describe 'fee calculation' do
    let(:duration) { 15 }
    let(:cart) { create(:cart, duration: duration) }
    let(:book_1) { create(:book, base_rental_price: 5_000, buyout_price: 20_000) }
    let(:book_2) { create(:book, base_rental_price: 10_000, buyout_price: 30_000) }
    let!(:cart_items) do
      [
        create(:cart_item, cart: cart, quantity: 1, book: book_1),
        create(:cart_item, cart: cart, quantity: 2, book: book_2)
      ]
    end

    describe '#deposit_fee' do
      let(:expected_fee) do
        (book_1.buyout_price * 1 + book_2.buyout_price * 2)
      end

      it 'returns correct deposit fee' do
        expect(cart.deposit_fee).to eq(expected_fee)
      end
    end

    describe '#rental_fee' do
      let(:expected_fee) do
        (book_1.base_rental_price * 1 + book_2.base_rental_price * 2) * RENTAL_RATE[duration]
      end

      shared_examples 'rental_fee' do
        it 'returns correct rental fee' do
          expect(cart.rental_fee).to eq(expected_fee)
        end
      end

      context 'duration = 15' do
        let(:duration) { 15 }

        include_examples 'rental_fee'
      end

      context 'duration = 30' do
        let(:duration) { 30 }

        include_examples 'rental_fee'
      end

      context 'duration = 45' do
        let(:duration) { 45 }

        include_examples 'rental_fee'
      end
    end
  end
end
