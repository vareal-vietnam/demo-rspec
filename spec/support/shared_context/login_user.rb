# frozen_string_literal: true

RSpec.shared_context 'login user' do
  let(:current_user) { create(:user, :confirmed) }

  before do
    sign_in(current_user)
  end
end
