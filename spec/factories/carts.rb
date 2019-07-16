# frozen_string_literal: true

# == Schema Information
#
# Table name: carts
#
#  id            :bigint(8)        not null, primary key
#  duration      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  book_owner_id :bigint(8)        not null
#  user_id       :bigint(8)
#
# Indexes
#
#  index_carts_on_book_owner_id  (book_owner_id)
#  index_carts_on_user_id        (user_id)
#

FactoryBot.define do
  factory :cart do
    user
    book_owner_id { create(:book).user_id }

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
