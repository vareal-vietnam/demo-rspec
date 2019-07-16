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

require 'rails_helper'

RSpec.describe AppointmentSlot, type: :model do
  it { should belong_to(:appointment) }
  it { should belong_to(:address) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }

  describe 'validates start_time timeliness' do
    subject { build(:appointment_slot, start_time: Time.current) }

    it 'is not on or before current date' do
      expect(subject).not_to be_valid
    end
  end

  describe 'validates end_time timeliness' do
    subject { build(:appointment_slot, start_time: Time.current, end_time: Time.current) }

    it 'is not before start_time' do
      expect(subject).not_to be_valid
    end
  end
end
