# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssociateSimilarBooksJob, type: :job do
  describe '#perform' do
    let!(:book1) { create(:book, title: 'a good book') }
    let!(:book2) { create(:book, title: 'a good book') }
    let!(:book3) { create(:book, title: 'another-good-book') }

    subject(:job) { described_class.new }

    it 'creates 2 relations for book 1 and book 2' do
      expect { job.perform(book1) }.to change(SimilarBook, :count).by(2)

      expect(book1.similar_books).to match([book2])
      expect(book2.similar_books).to match([book1])
      expect(book3.similar_books).to be_empty
    end
  end
end
