# frozen_string_literal: true

require 'rails_helper'

describe AuthenticatedController, type: :controller do
  controller do
    def index
      render plain: 'success'
    end
  end

  let(:action) { get :index }

  context 'authenticate user' do
    include_context 'login user'

    it 'returns success string' do
      expect(action.body).to eq('success')
    end
  end

  context 'unauthenticated user' do
    it 'redirects to new_session path' do
      expect(action).to redirect_to(new_user_session_path)
    end
  end
end
