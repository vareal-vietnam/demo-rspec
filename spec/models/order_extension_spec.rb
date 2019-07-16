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

require 'rails_helper'

RSpec.describe OrderExtension, type: :model do
  it { should belong_to(:order) }

  it { should validate_numericality_of(:new_duration).only_integer.is_greater_than(0) }
  it { should validate_numericality_of(:old_duration).only_integer.is_greater_than(0) }
end
