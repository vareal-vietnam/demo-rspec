# frozen_string_literal: true

def get_response(filename)
  file = File.new("#{Rails.root}/spec/support/mock_response/tiki/#{filename}")
  {
    body: file,
    status: 200,
    headers: { 'content-type' => 'text/html' }
  }
end

RSpec.shared_context 'tiki/nha-gia-kim' do
  before do
    stub_request(:get, 'https://tiki.vn/nha-gia-kim-p378448.html').to_return(get_response('nha_gia_kim.html'))
  end
end

RSpec.shared_context 'tiki/5-cm-per-sec' do
  before do
    stub_request(:get, 'https://tiki.vn/5-centimet-tren-giay-p418676.html').to_return(get_response('5_cm_per_sec.html'))
  end
end
