# frozen_string_literal: true

# == Schema Information
#
# Table name: cities
#
#  id         :bigint(8)        not null, primary key
#  code       :string(16)       not null
#  name       :string(128)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint(8)        not null
#
# Indexes
#
#  index_cities_on_country_id  (country_id)
#

FactoryBot.define do
  factory :city do
    name { Faker::Address.city }
    code { Faker::Address.zip_code }
    association :country, factory: :country
  end
end
