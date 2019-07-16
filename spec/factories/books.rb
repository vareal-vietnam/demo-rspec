# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                :bigint(8)        not null, primary key
#  author            :string           default("")
#  base_rental_price :decimal(9, 2)
#  buyout_price      :decimal(9, 2)
#  description       :text             default("")
#  popularity        :integer          default(0), not null
#  publication_date  :date
#  publisher         :string           default("")
#  quantity          :integer          default(1), not null
#  rating            :decimal(2, 1)    default(0.0)
#  title             :string           not null
#  total_pages       :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint(8)
#
# Indexes
#
#  index_books_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph(10) }
    author { Faker::Book.author }
    publisher { Faker::Book.publisher }
    publication_date { 1.year.ago }
    total_pages { 120 }
    base_rental_price { rand(10..40) * 1000 }
    buyout_price { rand(50..100) * 100 }

    user
  end
end
