# frozen_string_literal: true

require 'rails_helper'

describe CartService::Validator do
  let(:cart) { create :cart, duration: 15 }
  let!(:cart_item_1) { create :cart_item, cart: cart, quantity: 1 }
  subject(:service) { described_class.new(cart) }

  describe '#exec' do
    context 'cart is valid' do
      it 'returns true' do
        service.exec
        expect(service).to be_success
      end
    end

    context 'out of stock' do
      let!(:cart_item_2) { create :cart_item, cart: cart, quantity: 100 }

      it 'returns false' do
        service.exec
        expect(service).not_to be_success
        expect(service.errors).to eq([I18n.t('books.errors.not_enough_quantity')])
      end
    end
  end
end
