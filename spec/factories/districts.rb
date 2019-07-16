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

FactoryBot.define do
  factory :district do
    association :city, factory: :city
    name { 'MyString' }
  end
end
