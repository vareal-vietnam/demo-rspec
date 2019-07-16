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

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  it { should have_many(:appointment_slots).dependent(:destroy) }
  it { should belong_to(:creator) }
  it { should belong_to(:recipient) }

  it { validate_length_of(:appointment_slots).is_at_least(3) }
end
