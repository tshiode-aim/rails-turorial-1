require 'rails_helper'
require 'spec_helper'

describe UsersController, type: :feature do
  subject { page }

  let(:user) { create(:michael) }
  let(:other_user) { create(:archer) }

  context 'when visit index page' do
    before { visit users_path }

    it 'should redirect login page' do
      is_expected.to have_selector("form[action='#{login_path}']")
    end
  end

  context 'when visit signup page' do
    before { visit signup_path }

    it_should_behave_like 'should response code 200'
  end

  context 'when visit edit page' do
    context 'with not login' do
      before { visit edit_user_path(user) }

      it 'should redirect login page' do
        is_expected.to have_selector("form[action='#{login_path}']")
      end
    end

    context 'with login as wrong user' do
      before do
        log_in_as(other_user)
        visit edit_user_path(user)
      end

      it 'should redirect root page' do
        is_expected.to have_selector('h1', text: 'Welcome to the Sample App')
      end
    end
  end

  context 'when update user' do
    context 'with not login' do
      before do
        page.driver.submit :patch, user_path(user), user: {
          name: user.name,
          email: user.email
        }
      end

      it 'should redirect login page' do
        is_expected.to have_selector("form[action='#{login_path}']")
      end
    end

    context 'with login as wrong user' do
      before do
        log_in_as(other_user)
        page.driver.submit :patch, user_path(user), user: {
          name: user.name,
          email: user.email
        }
      end

      it 'should redirect root page' do
        is_expected.to have_selector('h1', text: 'Welcome to the Sample App')
      end
    end
  end

  context 'when destroy user' do
    context 'with not login' do
      before do
        page.driver.submit :delete, user_path(user), user: {
          name: user.name,
          email: user.email
        }
      end

      it 'should redirect login page' do
        is_expected.to have_selector("form[action='#{login_path}']")
      end
    end

    context 'with login as wrong user' do
      before do
        log_in_as(other_user)
        page.driver.submit :delete, user_path(user), user: {
          name: user.name,
          email: user.email
        }
      end

      it 'should redirect root page' do
        is_expected.to have_selector('h1', text: 'Welcome to the Sample App')
      end
    end
  end
end
