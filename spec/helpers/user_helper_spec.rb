# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserHelper do
  describe '#user_avatar_image' do
    context 'user has profile picture' do
      let(:user) { create(:user, profile_picture_url: Faker::Internet.url) }

      it 'returns user profile picture' do
        profile_picture = image_tag(user.profile_picture_url, alt: 'avatar', class: 'avatar-icon')
        expect(helper.user_avatar_image(user)).to eq(profile_picture)
      end
    end

    context 'user without profile picture' do
      let(:user) { create(:user, profile_picture_url: '') }
      let(:default_profile_picture) { 'application/default-avatar' }

      it 'returns default profile picture' do
        expect(helper.user_avatar_image(user)).to include(default_profile_picture)
      end
    end
  end
end
