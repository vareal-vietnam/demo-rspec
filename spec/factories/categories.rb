# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id          :bigint(8)        not null, primary key
#  description :string           default("")
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :category do
    name { Faker::Book.genre }
    description { Faker::Lorem.paragraph(10) }
  end
end
