# frozen_string_literal: true

require 'rails_helper'

describe BooksHelper do
  describe '#adjust_book_quantity' do
    let(:book_1) { create(:book, quantity: 1) }
    let(:book_2) { create(:book, quantity: 1) }
    let(:cart_items) { [CartItem.new(quantity: 1, book_id: book_1.id)] }
    let(:cart) { Cart.new(items: cart_items) }

    it 'adjusts quantity of the book based on book item' do
      expect(adjust_book_quantity(book_1, cart).quantity).to be_zero
      expect(adjust_book_quantity(book_2, cart).quantity).to eq(1)
    end

    context 'when have no cart' do
      let(:cart) { nil }

      it 'returns the original book quantity' do
        expect(adjust_book_quantity(book_1, cart).quantity).to eq(book_1.quantity)
      end
    end
  end
end
