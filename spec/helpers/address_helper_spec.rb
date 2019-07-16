# frozen_string_literal: true

require 'rails_helper'

describe AddressHelper do
  describe '#display_hidden_address' do
    let(:address) { create(:address, line_1: '123/1', street: 'Nguyen Van Troi') }

    it 'returns the concantenated of street, district and city' do
      expected_result = [address.street, address.district_name, address.city_name].join(', ')
      expect(helper.display_hidden_address(address)).to eq(expected_result)
    end
  end
end
