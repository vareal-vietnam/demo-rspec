# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: orders
#
#  id                   :bigint(8)        not null, primary key
#  duration             :integer          not null
#  last_event_changed   :datetime         not null
#  rental_counting_from :datetime         not null
#  rental_rate          :json
#  state                :integer          default("confirming_pickup"), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  book_owner_id        :bigint(8)        not null
#  cart_id              :bigint(8)        not null
#  user_id              :bigint(8)        not null
#
# Indexes
#
#  index_orders_on_book_owner_id  (book_owner_id)
#  index_orders_on_cart_id        (cart_id)
#  index_orders_on_state          (state)
#  index_orders_on_user_id        (user_id)
#

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_many :order_items }
  it { should have_many :order_extensions }
  it { should belong_to :user }
  it { should belong_to :cart }
  it { should belong_to :book_owner }
  it { should have_one(:pending_pickup_appointment).conditions(appointment_type: :pickup, state: :pending) }

  it { should validate_presence_of :duration }
  it { should validate_presence_of :rental_counting_from }
  it { should validate_presence_of :rental_rate }

  describe 'state machine' do
    subject(:order) { Order.new(id: 1) }

    describe 'happy case' do
      it 'allows transitions' do
        expect(order).to have_state(:confirming_pickup)
        expect(order).to transition_from(:confirming_pickup).to(:picking_up).on_event(:confirm_pick_up_time)
        expect(order).to transition_from(:picking_up).to(:verifying_pick_up).on_event(:verify_pick_up)
        expect(order).to transition_from(:verifying_pick_up_report, :verifying_pick_up).to(:enjoying).on_event(:pickup_success)
        expect(order).to transition_from(:enjoying).to(:verifying_return).on_event(:verify_return)
        expect(order).to transition_from(:verifying_return).to(:completed).on_event(:return_success)
        expect(order).to transition_from(:enjoying).to(:enjoying).on_event(:extend_rental_duration)
        expect(order).to transition_from(:verifying_pick_up_report).to(:enjoying).on_event(:pickup_success)
        expect(order).to transition_from(:confirming_pickup, :picking_up).to(:cancelled).on_event(:cancel)
        expect(order).to transition_from(:verifying_pick_up).to(:verifying_pick_up_report).on_event(:report)
        expect(order).to transition_from(:verifying_return).to(:verifying_return_report).on_event(:report)
        expect(order).to transition_from(:verifying_pick_up_report).to(:cancelled).on_event(:pick_up_failed)
      end
    end

    describe 'buyout if overdue' do
      before do
        allow(order).to receive(:extensible?).and_return(false)
      end

      it 'allows buyout but not extend' do
        expect(order).not_to allow_event(:extend_rental_duration)
        expect(order).to transition_from(:enjoying).to(:completed).on_event(:buyout)
        expect(order).to transition_from(:verifying_return_report).to(:completed).on_event(:buyout)
      end
    end

    describe 'extend of extensible' do
      before do
        allow(order).to receive(:extensible?).and_return(true)
      end

      it 'allows extend but not buyout' do
        expect(order).not_to allow_event(:buyout)
        expect(order).to transition_from(:enjoying, :verifying_return_report).to(:enjoying).on_event(:extend_rental_duration)
      end
    end

    describe 'log event changed' do
      it 'updates last_event_changed' do
        before_last_event_change = order.last_event_changed
        order.confirm_pick_up_time
        expect(order.last_event_changed).not_to eq(before_last_event_change)
      end

      it 'creates new OrderHistory record' do
        expect { order.confirm_pick_up_time }.to change(OrderHistory, :count).by(1)
      end
    end
  end
end

# rubocop:enable Metrics/LineLength
