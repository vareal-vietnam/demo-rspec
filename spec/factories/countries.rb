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

FactoryBot.define do
  factory :country do
    name { Faker::Address.country }
    code { Faker::Address.country_code }
  end
end
