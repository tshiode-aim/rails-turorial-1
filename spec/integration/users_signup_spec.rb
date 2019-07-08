require 'rails_helper'
require 'spec_helper'

describe 'users signup', type: :feature do
  subject { page }

  context 'when signup invalid information' do
    it 'should not increase user count' do
      expect {
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        click_on 'Create my account'
      }.to change(User, :count).by(0)
    end

    describe 'after redirect page' do
      before do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        click_on 'Create my account'
      end

      it 'should have error messages' do
        is_expected.to have_selector('div#error_explanation > ul > li', text: "Name can't be blank")
        is_expected.to have_selector('div#error_explanation > ul > li', text: 'Email is invalid')
        is_expected.to have_selector('div#error_explanation > ul > li', text: "Password confirmation doesn't match Password")
        is_expected.to have_selector('div#error_explanation > ul > li', text: 'Password is too short (minimum is 6 characters)')
      end

      it 'should redirect signup page' do
        is_expected.to have_selector('form[action="/signup"]')
      end
    end
  end

  context 'when signup valid information' do
    it 'should increase user count' do
      expect {
        visit signup_path
        fill_in 'Name', with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_on 'Create my account'
      }.to change(User, :count).by(1)
    end

    describe 'after redirect page' do
      before do
        visit signup_path
        fill_in 'Name', with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'
        click_on 'Create my account'
      end

      it 'should not have any error messages' do
        is_expected.to have_no_selector('div#error_explanation')
      end

      it 'should redirect user page' do
        is_expected.to have_selector('section.user_info')
      end
    end
  end
end
