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

require 'rails_helper'

RSpec.describe SimilarBook, type: :model do
  let(:book) { create(:book) }
  let(:other_book) { create(:book) }

  subject(:similar_book) { SimilarBook.new(book: book, other_book: other_book) }

  it { should belong_to :book }
  it { should belong_to :other_book }

  describe 'validates simliar_books_validity' do
    context 'valid relationship' do
      it 'is valid' do
        expect(similar_book).to be_valid
      end
    end

    context 'both books are just the same' do
      let(:other_book) { book }

      it 'is invalid' do
        expect(similar_book).not_to be_valid
      end
    end
  end
end
