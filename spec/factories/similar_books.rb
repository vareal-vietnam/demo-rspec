# frozen_string_literal: true

# == Schema Information
#
# Table name: similar_books
#
#  id            :bigint(8)        not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  book_id       :bigint(8)        not null
#  other_book_id :bigint(8)        not null
#
# Indexes
#
#  index_similar_books_on_book_id_and_other_book_id  (book_id,other_book_id) UNIQUE
#  index_similar_books_on_other_book_id              (other_book_id)
#

FactoryBot.define do
  factory :similar_book do
  end
end
