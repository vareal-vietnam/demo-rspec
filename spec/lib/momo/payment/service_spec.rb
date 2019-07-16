# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/lib/momo/momo"

describe Momo::Payment::Service do
  describe '#request_payment' do
    subject(:service) { described_class.new(request) }

    let(:request) do
      Momo::Payment::Request.new(
        'id' => request_id,
        'order_id' => order_id,
        'amount' => '50000',
        'order_info' => 'test pay by BookForward',
        'notify_url' => 'https://dummy-url.com',
        'return_url' => 'http://localhost:3333',
        'extra_data' => 'name=test;comp=BookForward'
      )
    end

    context 'request is success' do
      let(:request_id) { 'd8c99a22-348d-49c2-9b1e-2031f0eefb37' }
      let(:order_id) { 'c782d94a-6ea6-4f49-83a9-6c30a5b23dd4' }

      it 'is success' do
        VCR.use_cassette 'momo/request_payment' do
          resp = service.request_payment
          expect(resp).to be_success
          expect(resp).to be_verified
        end
      end
    end

    context 'order_id exists' do
      let(:request_id) { '6fcd56d3-58ec-4c0c-bf48-8c5033c095cf' }
      let(:order_id) { '7a0cec41-9491-40e3-aaa5-735e5117a5f1' }

      it 'is not success' do
        VCR.use_cassette 'momo/request_payment_failed' do
          resp = service.request_payment
          expect(resp).to be_errored
          expect(resp).to be_verified
          expect(resp.error_code).to eq(6)
        end
      end
    end
  end
end
