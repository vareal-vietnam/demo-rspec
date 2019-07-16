# frozen_string_literal: true

# == Schema Information
#
# Table name: cart_items
#
#  id         :bigint(8)        not null, primary key
#  quantity   :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint(8)        not null
#  cart_id    :bigint(8)        not null
#
# Indexes
#
#  index_cart_items_on_book_id  (book_id)
#  index_cart_items_on_cart_id  (cart_id)
#

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  it { should belong_to(:cart) }
  it { should belong_to(:book) }

  it { should validate_numericality_of(:quantity).is_greater_than(0) }
end
