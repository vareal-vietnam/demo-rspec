# frozen_string_literal: true

require 'rails_helper'

describe CartService::AddItem do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:cart) { nil }
  subject(:service) { described_class.new(user, cart, book) }

  describe '#exec' do
    shared_examples 'success exec' do
      it 'succeeds' do
        service.exec
        expect(service).to be_success
      end
    end

    shared_examples 'fail exec' do
      it 'fails' do
        service.exec
        expect(service).not_to be_success
      end
    end

    context 'when the book is out of stock' do
      let(:book) { create(:book, quantity: 0) }

      include_examples 'fail exec'
    end

    context 'when a new cart' do
      include_examples 'success exec'

      it 'creates a new cart' do
        expect { service.exec }.to change(Cart, :count).by(1)
      end

      it 'creates a cart with items' do
        service.exec
        cart = Cart.last
        expect(cart.items.map(&:book)).to include(book)
      end
    end

    context 'when adding to an existing cart' do
      let(:another_book) { create(:book, quantity: 2) }
      let!(:cart) { create(:cart, user: user, book_owner_id: another_book.user_id) }
      let!(:cart_item) { create(:cart_item, cart: cart, book: another_book, quantity: 1) }

      context 'adding new item of a different owner' do
        include_examples 'fail exec'
      end

      context 'adding duplicated book to the cart' do
        let(:another_book) { book }

        context 'when the book has quantity > 1' do
          let(:book) { create(:book, quantity: 2) }

          include_examples 'success exec'

          it 'doesnt increase number of cart items' do
            expect { service.exec }.to change(cart.items, :count).by(0)
          end

          it 'increases quantity of the existing cart item' do
            service.exec
            expect(cart_item.reload.quantity).to eq(2)
          end
        end

        context 'when the book has quantity = 1' do
          include_examples 'fail exec'
        end
      end

      context 'adding a new book to the cart' do
        let(:book) { create(:book, user: another_book.user) }

        include_examples 'success exec'

        it 'adds another item to the cart' do
          expect { service.exec }.to change(cart.items, :count).by(1)
        end
      end
    end
  end
end
