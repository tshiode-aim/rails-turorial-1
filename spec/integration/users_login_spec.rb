require 'rails_helper'
require 'spec_helper'

describe 'users login', type: :feature do
  shared_context 'login_with_current_user' do
    let(:user) { create(:user) }

    before do
      visit login_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Log in'
    end
  end

  subject { page }

  include_context 'login_with_current_user'

  let(:email) { user.email }
  let(:password) { 'password' }

  context 'when login with invalid information' do
    let(:password) { '' }

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

  context 'when login with valid information' do
    it 'should redirect user page' do
      is_expected.to have_selector('section.user_info')
      is_expected.to have_selector("a[href='#{logout_path}']")
      is_expected.to have_selector("a[href='#{user_path(user)}']")
    end

    it 'should not redirect login page' do
      is_expected.to have_no_selector("a[href='#{login_path}']")
    end
  end

  context 'when logout after login' do
    before { click_link 'Log out' }

    it 'should redirect root_path' do
      is_expected.to have_selector("a[href='#{login_path}']")
    end

    it 'should not redirect user page' do
      is_expected.to have_no_selector("a[href='#{logout_path}']")
      is_expected.to have_no_selector("a[href='#{user_path(user)}']")
    end
  end
end
