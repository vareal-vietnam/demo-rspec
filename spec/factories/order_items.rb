# frozen_string_literal: true

# == Schema Information
#
# Table name: order_items
#
#  id                :bigint(8)        not null, primary key
#  base_rental_price :decimal(9, 2)
#  buyout_price      :decimal(9, 2)
#  quantity          :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  book_id           :bigint(8)        not null
#  order_id          :bigint(8)        not null
#
# Indexes
#
#  index_order_items_on_book_id   (book_id)
#  index_order_items_on_order_id  (order_id)
#

FactoryBot.define do
  factory :order_item do
  end
end
