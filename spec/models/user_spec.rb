# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  profile_picture_url    :string
#  provider               :string
#  provider_uid           :string
#  rating                 :decimal(2, 1)    default(0.0)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:addresses) }
  it { should have_many(:books) }
  it { should have_many(:carts) }
  it { should have_many(:lending_orders) }
  it { should have_many(:renting_orders) }

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '.from_omniauth' do
    let(:user_name) { Faker::Name.name }
    let(:user_email) { Faker::Internet.email }
    let(:user_profile_picture_url) { Faker::Internet.url }
    let(:user_provider_name) { 'google_oauth2' }
    let(:user_provider_uid) { Faker::Internet.password }

    let(:auth_params) do
      OpenStruct.new(
        provider: user_provider_name,
        uid: user_provider_uid,
        info: OpenStruct.new(
          name: user_name,
          email: user_email,
          image: user_profile_picture_url
        )
      )
    end

    context 'user not exists' do
      it 'increates user count by 1' do
        expect { User.from_omniauth(auth_params) }.to change(User, :count).by(1)
      end

      it 'returns correct user' do
        user = User.from_omniauth(auth_params)
        expect(user.email).to eq(user_email)
        expect(user.name).to eq(user_name)
        expect(user.profile_picture_url).to eq(user_profile_picture_url)
        expect(user.email).to eq(user_email)
        expect(user.provider).to eq(user_provider_name)
        expect(user.provider_uid).to eq(user_provider_uid)
      end
    end

    context 'user already exists' do
      context 'user already login with provider account' do
        let!(:user) { create(:user, email: user_email, provider: user_provider_name, provider_uid: user_provider_uid) }

        it 'doesnt create new user' do
          expect { User.from_omniauth(auth_params) }.to change(User, :count).by(0)
        end

        it 'returns correct user' do
          expect(user).to eq(User.from_omniauth(auth_params))
        end
      end

      context 'user already signup with email' do
        let!(:user) { create(:user, email: user_email, confirmed_at: nil) }

        before do
          @return_user = User.from_omniauth(auth_params)
        end

        it 'doesnt create new user' do
          expect { User.from_omniauth(auth_params) }.to change(User, :count).by(0)
        end

        it 'returns corret exists user' do
          expect(@return_user).to eq(user)
        end

        it 'sets confirmed_at' do
          expect(@return_user).to be_confirmed
        end
      end
    end
  end
end
