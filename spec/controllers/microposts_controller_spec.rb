require 'rails_helper'
require 'spec_helper'

describe MicropostsController do
  let!(:user) { create(:user) }
  let!(:micropost) { create(:micropost, user: user) }

  describe '#create' do
    context 'with login' do
      before { set_current_user(user) }

      it 'should create micropost' do
        expect {
          post :create, params: { micropost: { content: 'Hey!' } }
        }.to change(Micropost, :count).by(1)
      end

      it 'should redirect root page' do
        post :create, params: { micropost: { content: 'Hey!' } }
        expect(response).to redirect_to root_url
      end
    end

    context 'with not login' do
      it 'should not create micropost' do
        expect {
          post :create, params: { micropost: { content: 'Hey!' } }
        }.to change(Micropost, :count).by(0)
      end

      it 'should redirect login page' do
        post :create, params: { micropost: { content: 'Hey!' } }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do
    context 'with login' do
      before { set_current_user(user) }

      it 'should destroy micropost' do
        expect {
          delete :destroy, params: { id: micropost.id }
        }.to change(Micropost, :count).by(-1)
      end

      it 'should redirect to root page' do
        delete :destroy, params: { id: micropost.id }
        expect(response).to redirect_to root_url
      end
    end

    context 'with not login' do
      it 'should not destroy micropost' do
        expect {
          delete :destroy, params: { id: micropost.id }
        }.to change(Micropost, :count).by(0)
      end

      it 'should redirect to login page' do
        delete :destroy, params: { id: micropost.id }
        expect(response).to redirect_to login_url
      end
    end

    context 'with other user' do
      before { set_current_user(user) }

      let!(:other_user_micropost) { create(:micropost) }

      it 'should not destroy micropost' do
        expect {
          delete :destroy, params: { id: other_user_micropost.id }
        }.to change(Micropost, :count).by(0)
      end

      it 'should redirect to root page' do
        delete :destroy, params: { id: other_user_micropost.id }
        expect(response).to redirect_to root_url
      end
    end
  end
end
