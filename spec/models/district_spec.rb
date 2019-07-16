# frozen_string_literal: true

# == Schema Information
#
# Table name: districts
#
#  id         :bigint(8)        not null, primary key
#  name       :string(128)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  city_id    :bigint(8)        not null
#
# Indexes
#
#  index_districts_on_city_id  (city_id)
#

require 'rails_helper'

RSpec.describe District, type: :model do
  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_most(128) }
  it { should validate_presence_of :city_id }

  it { should belong_to :city }
end
