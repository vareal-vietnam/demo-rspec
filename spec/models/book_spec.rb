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

require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :base_rental_price }
  it { should validate_presence_of :buyout_price }

  it { should have_and_belong_to_many :categories }
  it { should have_many :similar_book_relations }
  it { should have_many :similar_books }

  describe 'callbacks' do
    describe 'after_create associate_similar_books' do
      let(:book) { build(:book) }

      it 'enqueues the job' do
        expect { book.save }.to have_enqueued_job.with(book)
      end
    end
  end

  describe '#out_of_stock?' do
    it 'returns false when quantity is not 0' do
      book = Book.new(quantity: 1)
      expect(book).not_to be_out_of_stock
    end

    it 'returns true when quantity is 0' do
      book = Book.new(quantity: 0)
      expect(book).to be_out_of_stock
    end
  end
end
