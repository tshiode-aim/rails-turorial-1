require 'rails_helper'
require 'spec_helper'

describe UsersController, type: :feature do
  subject { page }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'when visit index page' do
    before { visit users_path }

    it_behaves_like 'should redirect login page'
  end

  context 'when visit signup page' do
    before { visit signup_path }

    it_behaves_like 'should response code 200'
  end

  context 'when visit edit page' do
    context 'with not login' do
      before { visit edit_user_path(user) }

      it_behaves_like 'should redirect login page'
    end

    context 'with login as wrong user' do
      before do
        log_in_as(other_user)
        visit edit_user_path(user)
      end

      it_behaves_like 'should redirect members root page'
    end
  end

  context 'when update user' do
    let(:new_name) { 'new_name' }
    let(:new_email) { 'new@example.com' }

    context 'with not login' do
      before do
        page.driver.submit :patch, user_path(user), user: {
          name: new_name,
          email: new_email
        }
      end

      it_behaves_like 'should redirect login page'
    end

    context 'with login as wrong user' do
      before do
        log_in_as(other_user)
        page.driver.submit :patch, user_path(user), user: {
          name: new_name,
          email: new_email
        }
      end

      it_behaves_like 'should redirect members root page'
    end
  end

  context 'when destroy user' do
    context 'with not login' do
      before do
        page.driver.submit :delete, user_path(user), {}
      end

      it_behaves_like 'should redirect login page'
    end

    context 'with login as wrong user' do
      before do
        log_in_as(other_user)
        page.driver.submit :delete, user_path(user), {}
      end

      it_behaves_like 'should redirect members root page'
    end
  end

  context 'when visit following page without login' do
    before { visit following_user_path(user) }

    it_behaves_like 'should redirect login page'
  end

  context 'when visit followers page without login' do
    before { visit followers_user_path(user) }

    it_behaves_like 'should redirect login page'
  end
end
