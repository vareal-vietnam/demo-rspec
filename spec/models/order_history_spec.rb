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

require 'rails_helper'

RSpec.describe OrderHistory, type: :model do
  it { should belong_to(:order) }

  it { should validate_presence_of(:event) }
  it { should validate_presence_of(:from_state) }
  it { should validate_presence_of(:to_state) }
end
