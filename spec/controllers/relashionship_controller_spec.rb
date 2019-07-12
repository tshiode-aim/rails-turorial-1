require 'rails_helper'
require 'spec_helper'

describe RelationshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe '#create' do
    context 'when follow a user the standard way' do
      before { set_current_user(user) }

      subject { post :create, params: { followed_id: other_user.id } }

      it 'should increase following users' do
        expect { subject }.to change(Relationship, :count).by(1)
      end
    end

    context 'when follow a user with Ajax' do
      before { set_current_user(user) }

      subject { post :create, xhr: true, params: { followed_id: other_user.id } }

      it 'should increase following users' do
        expect { subject }.to change(user.following, :count).by(1)
      end
    end

    context 'when follow with not login' do
      subject { post :create, params: { followed_id: other_user.id } }

      it 'should not create relationship' do
        expect { subject }.to change(Relationship, :count).by(0)
      end

      it 'should redirect login page' do
        is_expected.to redirect_to login_url
      end
    end
  end

  describe '#destroy' do
    let!(:relationship) { create(:relationship, follower: user, followed: other_user) }

    context 'when unfollow a user the standard way' do
      subject { delete :destroy, params: { id: relationship.id } }

      it 'should decrease following users' do
        set_current_user(user)
        expect { subject }.to change(Relationship, :count).by(-1)
      end
    end

    context 'when unfollow a user with Ajax' do
      subject { delete :destroy, xhr: true, params: { id: relationship.id } }

      it 'should decrease following users' do
        set_current_user(user)
        expect { subject }.to change(Relationship, :count).by(-1)
      end
    end

    context 'when unfollow with not login' do
      subject { delete :destroy, params: { id: relationship.id } }

      it 'should not destroy relationship' do
        expect { subject }.to change(Relationship, :count).by(0)
      end

      it 'should redirect login page' do
        is_expected.to redirect_to login_url
      end
    end
  end
end
