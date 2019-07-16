# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:cart) { create(:cart, duration: 15, user_id: nil) }
  let(:user) { create(:user) }
  let!(:cart_item_1) { create(:cart_item, cart: cart, quantity: 1) }
  let!(:cart_item_2) { create(:cart_item, cart: cart) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_cart).and_return(cart)
  end

  describe 'GET #show' do
    context 'not has current cart' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_cart).and_return(nil)
      end

      it 'does nothing' do
        get :show
        expect(assigns(:show_momo_modal)).to eq(nil)
        expect(session[:momo_modal_shown]).to eq(nil)
      end
    end

    context 'has current cart' do
      it 'assigns show_momo_modal and session[:momo_modal_shown]' do
        get :show
        expect(assigns(:show_momo_modal)).to eq(true)
        expect(session[:momo_modal_shown]).to eq(cart.id)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroy cart_item_1' do
      delete :destroy, params: { cart_item_id: cart_item_1.id }
      expect(cart.items.pluck(:id)).to eq([cart_item_2.id])
    end
  end

  describe 'PUT #update' do
    it 'updates cart duration' do
      put :update, params: { cart: { duration: 30 } }, format: :js
      expect(cart.duration).to eq(30)
    end
  end

  describe 'PUT #update_item' do
    it 'updates cart item quantity' do
      put :update_item, params: { cart_item_id: cart_item_1.id, cart_item: { quantity: 10 } }
      expect(cart_item_1.reload.quantity).to eq(10)
    end
  end
end
