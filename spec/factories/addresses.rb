# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id          :bigint(8)        not null, primary key
#  line_1      :string
#  line_2      :string
#  postal_code :string
#  street      :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  city_id     :bigint(8)        not null
#  district_id :bigint(8)        not null
#  user_id     :bigint(8)        not null
#
# Indexes
#
#  index_addresses_on_city_id      (city_id)
#  index_addresses_on_district_id  (district_id)
#  index_addresses_on_user_id      (user_id)
#

FactoryBot.define do
  factory :address do
    city
    district
    user

    street { Faker::Address.street_name }
    line_1 { Faker::Address.street_address }
    line_2 { Faker::Address.secondary_address }
    postal_code { Faker::Address.postcode }
  end
end
