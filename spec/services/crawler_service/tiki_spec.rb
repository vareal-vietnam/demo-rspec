# frozen_string_literal: true

require 'rails_helper'

describe CrawlerService::Tiki do
  describe '#exec' do
    subject(:service) { described_class.new }

    context 'Crawl Nha Gia Kim' do
      let(:url) { 'https://tiki.vn/nha-gia-kim-p378448.html' }

      include_context 'tiki/nha-gia-kim'

      it 'returns the book with data' do
        book = service.exec(url)

        expect(book.title).to eq('Nhà Giả Kim')
        expect(book.author).to eq('Paulo Coelho')
        expect(book.raw_cover_photo_url).to eq('https://salt.tikicdn.com/cache/550x550/media/catalog/product/i/m/img117.u3059.d20170616.t100547.729023.jpg')
        expect(book.buyout_price).to eq(69_000)
        expect(book.publication_date).to eq('10-2013'.to_date)
        expect(book.publisher).to eq('Nhà Xuất Bản Văn Học')
        expect(book.total_pages).to eq(228)
        expect(book.description).to include('Nhà Giả Kim')
      end
    end

    context 'Crawl 5 cm per second' do
      let(:url) { 'https://tiki.vn/5-centimet-tren-giay-p418676.html' }

      include_context 'tiki/5-cm-per-sec'

      it 'returns the book with data' do
        book = service.exec(url)

        expect(book.title).to eq('5 Centimet Trên Giây')
        expect(book.author).to eq('Shinkai Makoto')
        expect(book.raw_cover_photo_url).to eq('https://salt.tikicdn.com/cache/550x550/media/catalog/product/i/m/img894.u3059.d20170616.t102330.519090.jpg')
        expect(book.buyout_price).to eq(50_000)
        expect(book.publication_date).to eq('12-2014'.to_date)
        expect(book.publisher).to eq('Nhà Xuất Bản Văn Học')
        expect(book.total_pages).to eq(188)
        expect(book.description).to include('5cm/s')
      end
    end
  end
end
