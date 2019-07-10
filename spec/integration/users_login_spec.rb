require 'rails_helper'
require 'spec_helper'

describe 'users login', type: :feature do
  subject { page }

  let(:user) { create(:user) }

  context 'when login with valid information' do
    before { log_in_as(user) }

    it 'should redirect user page' do
      is_expected.to have_selector('section.user_info')
      is_expected.to have_selector("a[href='#{logout_path}']")
      is_expected.to have_selector("a[href='#{user_path(user)}']")
    end

    it 'should not redirect login page' do
      is_expected.to have_no_selector("a[href='#{login_path}']")
    end
  end

  context 'when login with invalid information' do
    before { log_in_as(user, password: '') }

    it 'should redirect login page' do
      is_expected.to have_selector('form[action="/login"]')
    end

    it 'should have any error messages' do
      is_expected.to have_selector('div.alert.alert-danger')
    end

    context 'when visit another page' do
      before { visit root_path }

      it 'should clear error messages' do
        is_expected.to have_no_selector('div.alert.alert-danger')
      end
    end
  end

  context 'when logout after login' do
    before do
      log_in_as(user)
      logout
    end

    it 'should redirect root_path' do
      is_expected.to have_selector("a[href='#{login_path}']")
    end

    it 'should not redirect user page' do
      is_expected.to have_no_selector("a[href='#{logout_path}']")
      is_expected.to have_no_selector("a[href='#{user_path(user)}']")
    end
  end

  context 'when logout after logout' do
    before do
      log_in_as(user)
      logout
      force_logout
    end

    it 'should redirect root_path' do
      is_expected.to have_selector("a[href='#{login_path}']")
    end

    it 'should not redirect user page' do
      is_expected.to have_no_selector("a[href='#{logout_path}']")
      is_expected.to have_no_selector("a[href='#{user_path(user)}']")
    end
  end

  context 'when login with remembering' do
    before do
      allow(User).to receive(:new_token).and_return('remember_token')
      log_in_as(user, remember_me: true)
    end

    subject { page.driver.browser.rack_mock_session.cookie_jar['remember_token'] }

    it { is_expected.to eq 'remember_token' }
  end

  context 'when login without remembering' do
    before do
      log_in_as(user, remember_me: true)
      logout
      log_in_as(user, remember_me: false)
    end

    subject { page.driver.browser.rack_mock_session.cookie_jar['remember_token'] }

    it { is_expected.to be_blank }

    subject { user.reload.remember_digest }

    it { is_expected.to be_blank }
  end
end
