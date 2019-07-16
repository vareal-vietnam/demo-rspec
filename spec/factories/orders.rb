# frozen_string_literal: true

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

FactoryBot.define do
  factory :order do
    duration { 15 }
    rental_counting_from { Time.current }
    rental_rate { RENTAL_RATE }
    book_owner { create(:user) }
    cart
    user
  end
end
