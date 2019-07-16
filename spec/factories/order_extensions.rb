# frozen_string_literal: true

# == Schema Information
#
# Table name: order_extensions
#
#  id           :bigint(8)        not null, primary key
#  buyout       :boolean          default(FALSE), not null
#  new_duration :integer          not null
#  old_duration :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_id     :bigint(8)        not null
#
# Indexes
#
#  index_order_extensions_on_order_id  (order_id)
#

FactoryBot.define do
  factory :order_extension do
  end
end
