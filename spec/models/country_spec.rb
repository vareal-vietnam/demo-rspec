# frozen_string_literal: true

# == Schema Information
#
# Table name: countries
#
#  id         :bigint(8)        not null, primary key
#  code       :string(16)       not null
#  name       :string(128)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Country, type: :model do
  it { should validate_presence_of :code }
  it { should validate_length_of(:code).is_at_most(16) }
  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_most(128) }

  it { should have_many :cities }
end
