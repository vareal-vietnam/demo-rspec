# frozen_string_literal: true

# == Schema Information
#
# Table name: appointment_slots
#
#  id             :bigint(8)        not null, primary key
#  end_time       :datetime         not null
#  start_time     :datetime         not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  address_id     :bigint(8)
#  appointment_id :bigint(8)
#
# Indexes
#
#  index_appointment_slots_on_address_id      (address_id)
#  index_appointment_slots_on_appointment_id  (appointment_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (appointment_id => appointments.id)
#

FactoryBot.define do
  factory :appointment_slot do
    address
    association :appointment, factory: :cart_appointment
    start_time { Faker::Time.between(Time.current + 2.day, 7.days.from_now) }
    end_time { start_time + 30.minutes }
  end
end
