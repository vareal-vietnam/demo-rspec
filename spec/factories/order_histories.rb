# frozen_string_literal: true

# == Schema Information
#
# Table name: order_histories
#
#  id         :bigint(8)        not null, primary key
#  data       :json
#  event      :string           not null
#  from_state :integer          not null
#  to_state   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint(8)        not null
#
# Indexes
#
#  index_order_histories_on_order_id  (order_id)
#

FactoryBot.define do
  factory :order_history do
  end
end
