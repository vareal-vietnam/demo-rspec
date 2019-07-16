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

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it { should belong_to(:order) }
  it { should belong_to(:book) }

  it { should validate_presence_of(:base_rental_price) }
  it { should validate_presence_of(:buyout_price) }
  it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
end
