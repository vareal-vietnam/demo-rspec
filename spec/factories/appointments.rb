# frozen_string_literal: true

# == Schema Information
#
# Table name: appointments
#
#  id               :bigint(8)        not null, primary key
#  appointment_type :integer          default("pickup"), not null
#  note             :string           default("")
#  owner_type       :string
#  state            :integer          default("pending"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_id       :bigint(8)
#  owner_id         :bigint(8)
#  recipient_id     :bigint(8)
#
# Indexes
#
#  index_appointments_on_creator_id               (creator_id)
#  index_appointments_on_owner_type_and_owner_id  (owner_type,owner_id)
#  index_appointments_on_recipient_id             (recipient_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#  fk_rails_...  (recipient_id => users.id)
#

FactoryBot.define do
  factory :appointment do
    creator { create(:user) }
    recipient { create(:user) }

    trait :cart_owner do
      association :owner, factory: :cart
    end

    trait :order_appointment do
      association :owner, factory: :order
    end

    trait :pickup_appointment do
      appointment_type { :pickup }
    end

    trait :return_appointment do
      appointment_type { :return }
    end

    factory :cart_appointment, traits: %i[cart_owner pickup_appointment]

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
