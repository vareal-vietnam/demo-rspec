# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  include_context 'login user'

  shared_examples 'assigns common properties' do
    it 'assigns addresses' do
      action
      expect(assigns(:addresses)).to eq(cart.book_owner.addresses)
    end

    it 'assigns appointment_owner' do
      action
      expect(assigns(:appointment_owner)).to eq(cart)
    end

    context 'has no appointment yet' do
      it 'assigns a new appointment' do
        action
        expect(assigns(:appointment)).not_to be_persisted
      end
    end

    context 'has existing appointment' do
      let!(:appointment) do
        create(:appointment, :skip_validate, owner: cart, creator: current_user, recipient: cart.book_owner)
      end

      it 'sets appointment' do
        action
        expect(assigns(:appointment)).to eq(appointment)
      end
    end
  end

  shared_examples 'has no cart' do
    context 'has no cart' do
      let(:cart) { nil }

      it 'redirects to cart_show path' do
        expect(action).to redirect_to cart_path
      end
    end
  end

  let(:cart) { create(:cart, user: current_user, duration: 15) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_cart).and_return(cart)
  end

  describe 'GET #index' do
    let(:action) { get :index }

    include_examples 'has no cart'

    context 'has valid cart' do
      include_examples 'assigns common properties'
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, params: params, format: :js }
    let(:address) { cart.book_owner.addresses[0] }
    let(:appointment) { attributes_for(:appointment, owner: cart) }
    let(:appointment_slots) { attributes_for_list(:appointment_slot, 3, address_id: address.id) }
    let(:params) do
      {
        appointment: appointment.merge(appointment_slots_attributes: appointment_slots)
      }
    end

    it 'creates new appointment' do
      expect { action }.to change(Appointment, :count).by(1)
    end

    it 'creates 3 new appointment slots' do
      expect { action }.to change(AppointmentSlot, :count).by(3)
    end

    it 'redirects to review cart page' do
      expect(action).to redirect_to review_cart_path
    end

    context 'invalid appointment slots' do
      let(:appointment_slots) { attributes_for_list(:appointment_slot, 1, address_id: address.id) }

      it 'renders alerts' do
        expect(action).to render_template('shared/_alert')
      end
    end
  end

  describe 'PUT #update' do
    let(:action) { put :update, params: params, format: :js }
    let!(:appointment_slots) { create_list(:appointment_slot, 4, appointment: appointment) }
    let(:appointment) do
      create(:appointment, :skip_validate, owner: cart, creator: current_user, recipient: cart.book_owner)
    end
    let(:params) do
      {
        id: appointment.id,
        appointment: appointment.attributes.merge(
          appointment_slots_attributes: appointment_slots_attributes
        )
      }
    end

    context 'destroy a slot' do
      let(:appointment_slots_attributes) do
        attrs = appointment_slots.map(&:attributes)
        attrs.last['_destroy'] = '1'
        attrs
      end

      it 'decreases number of slot' do
        expect { action }.to change(AppointmentSlot, :count).by(-1)
      end
    end

    context 'adding new slot' do
      let(:appointment_slots_attributes) do
        attrs = appointment_slots.map(&:attributes)
        attrs << attributes_for(:appointment_slot, address_id: cart.book_owner.addresses[0].id)
        attrs
      end

      it 'increases number of slot' do
        expect { action }.to change(AppointmentSlot, :count).by(1)
      end
    end

    context 'updatee existing slot' do
      let(:appointment_slots_attributes) do
        attrs = appointment_slots.map(&:attributes)
        attrs[0]['start_time'] = 5.days.from_now
        attrs[0]['end_time'] = attrs[0]['start_time'] + 3.hours
        attrs
      end

      it 'changes data of the slot' do
        Timecop.freeze(Date.current) do
          action
          first_slot = appointment_slots_attributes[0]
          reloaded_slot = AppointmentSlot.find(first_slot['id'])
          expect(reloaded_slot.start_time).to eq(first_slot['start_time'])
          expect(reloaded_slot.end_time).to eq(first_slot['end_time'])
        end
      end
    end
  end
end
