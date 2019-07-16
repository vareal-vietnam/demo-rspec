# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  profile_picture_url    :string
#  provider               :string
#  provider_uid           :string
#  rating                 :decimal(2, 1)    default(0.0)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'Aa123456' }
    password_confirmation { 'Aa123456' }

    after(:create) do |user, _evaluator|
      create_list(:address, 1, user: user) if user.addresses.empty?
    end

    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end
