# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:van_hoc_nuoc_ngoai) { create(:category, name: 'Văn Học Nước Ngoài') }
  let(:user_1) { create(:user) }
  let(:address_user_1) { create(:address, user: user_1) }
  let(:user_2) { create(:user) }
  let(:address_user_2) { create(:address, user: user_2) }
  let!(:nha_gia_kim) do
    create(
      :book,
      title: 'Nhà giả kim',
      author: 'Paulo Coelho',
      description: 'Nhà giả kim',
      categories: [van_hoc_nuoc_ngoai],
      user: user_1
    )
  end
  let!(:tuoi_tre) do
    create(
      :book,
      title: 'Tuổi trẻ đáng giá bao nhiêu',
      author: 'Rosie Nguyễn',
      description: 'Tuổi trẻ đáng giá bao nhiêu',
      categories: [van_hoc_nuoc_ngoai],
      user: user_2
    )
  end
  let(:ngoai_van) { create(:category, name: 'Sách Ngoại Văn') }
  let!(:dac_nhan_tam) do
    create(
      :book,
      title: 'Đắc nhân tâm',
      author: 'Dale Carnegie',
      description: 'Đắc nhân tâm',
      categories: [ngoai_van],
      user: user_1
    )
  end
  let!(:tiep_thi) do
    create(
      :book,
      title: 'Tiếp thị 4.0',
      author: 'Philip Kotler',
      description: 'Kinh doanh thành công hơn',
      categories: [ngoai_van],
      user: user_2
    )
  end

  describe 'GET #index' do
    let(:latest_books) { Book.latest.limit(20).to_a }
    let(:top_books) { Book.top_books.limit(20).to_a }

    context 'without any params' do
      it 'prepare books data' do
        get :index
        expect(assigns(:latest_books)).to eq(latest_books)
        expect(assigns(:top_books)).to eq(top_books)
      end
    end

    context 'has empty params' do
      it 'prepare books data' do
        get :index, params: { q: { full_text_search: '' } }
        expect(assigns(:latest_books)).to eq(latest_books)
        expect(assigns(:top_books)).to eq(top_books)
      end
    end

    context 'has item in cart' do
      let(:cart) { create(:cart, book_owner_id: user_1.id) }

      before { session[:current_cart_id] = cart.id }

      it 'returns books of user_1 only' do
        get :index
        expect(assigns(:books)).to contain_exactly(nha_gia_kim, dac_nhan_tam)
      end
    end

    context 'has full_text_search params' do
      context 'matches some books at title' do
        it 'returns right @books' do
          get :index, params: { q: { full_text_search: 'kim' } }
          expect(assigns(:books).pluck(:id)).to include(nha_gia_kim.id)
        end
      end

      context 'matches some books at author' do
        it 'returns right @books' do
          get :index, params: { q: { full_text_search: 'dale' } }
          expect(assigns(:books).pluck(:id)).to include(dac_nhan_tam.id)
        end
      end

      context 'not found any book' do
        it 'returns empty @books' do
          get :index, params: { q: { full_text_search: 'kimx' } }
          expect(assigns(:books).pluck(:id)).to eq([])
        end
      end
    end

    context 'has categories_id_in params' do
      it 'returns right @books' do
        get :index, params: { q: { categories_id_in: van_hoc_nuoc_ngoai.id } }
        expect(assigns(:books).pluck(:id)).to match_array(van_hoc_nuoc_ngoai.books.pluck(:id))
      end
    end

    context 'has addresses_id_in params' do
      it 'returns right @books' do
        get :index, params: { q: { addresses_id_in: address_user_1.district_id } }
        expect(assigns(:books).pluck(:id)).to match_array(user_1.books.pluck(:id))
      end
    end
  end

  describe 'GET #show' do
    it 'returns @book' do
      get :show, params: { id: nha_gia_kim.id }
      expect(assigns(:book).id).to eq(nha_gia_kim.id)
    end
  end

  describe '#add_to_cart' do
    let(:book) { nha_gia_kim }
    let(:service) { Object.new }
    let(:expected_result) { true }
    let(:cart) { create(:cart) }
    let(:action) { post :add_to_cart, params: { id: book.id }, format: 'js' }
    let(:errors) { [] }

    before do
      allow_any_instance_of(CartService::AddItem).to receive(:exec).and_return(nil)
      allow_any_instance_of(CartService::AddItem).to receive(:success?).and_return(expected_result)
      allow_any_instance_of(CartService::AddItem).to receive(:cart).and_return(cart)
      allow_any_instance_of(CartService::AddItem).to receive(:errors).and_return(errors)
    end

    context 'success' do
      let(:expected_result) { true }

      it 'sets current_cart_id to session' do
        action
        expect(session[:current_cart_id]).to eq(cart.id)
      end

      it 'assigns cart' do
        action
        expect(assigns(:cart)).to eq(cart)
      end
    end

    context 'failure' do
      let(:expected_result) { false }
      let(:errors) { ['error'] }

      it 'redirects to book show page' do
        action
        expect(response).to redirect_to(book_path(book))
      end

      it 'shows the alerts' do
        action
        expect(flash[:danger]).to eq(errors)
      end
    end
  end
end
