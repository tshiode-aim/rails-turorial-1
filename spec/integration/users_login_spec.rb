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

  describe 'remembering' do
    let(:remember_token) { page.driver.browser.rack_mock_session.cookie_jar['remember_token'] }
    let(:remember_digest) { user.reload.remember_digest }

    context 'when login with remembering' do
      before { log_in_as(user, remember_me: true) }

      it 'should match remember_token and remember_digest' do
        expect(BCrypt::Password.new(remember_digest).is_password?(remember_token)).to be true
      end
    end

    context 'when without remembering' do
      before do
        log_in_as(user, remember_me: true)
        logout
        log_in_as(user, remember_me: false)
      end

      it 'should not exist remember_token and remember_digest' do
        expect(remember_token).to be_blank
        expect(remember_digest).to be_blank
      end
    end
  end
end
