require 'rails_helper'
require 'spec_helper'

describe 'users login', type: :feature do
  let(:user) { create(:user) }

  subject { page }

  def login_with_valid_user
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end

  context 'when login with invalid information' do
    before do
      visit login_path
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      click_button 'Log in'
    end

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
    before { login_with_valid_user }

    it 'should redirect user page' do
      is_expected.to have_selector('section.user_info')
      is_expected.to have_selector("a[href='#{logout_path}']")
      is_expected.to have_selector("a[href='#{user_path(user)}']")
    end

    it 'should not redirect login page' do
      is_expected.to have_no_selector("a[href='#{login_path}']")
    end
  end

  context 'when login with valid information followed by logout' do
    before do
      login_with_valid_user
      click_link 'Log out'
    end

    it 'should redirect root_path' do
      is_expected.to have_selector("a[href='#{login_path}']")
    end

    it 'should not redirect user page' do
      is_expected.to have_no_selector("a[href='#{logout_path}']")
      is_expected.to have_no_selector("a[href='#{user_path(user)}']")
    end
  end
end
