require 'rails_helper'
require 'spec_helper'

describe 'users signup', type: :feature do
  before { ActionMailer::Base.deliveries.clear }

  subject { page }

  context 'when signup valid information' do
    it 'should increase user count' do
      expect {
        visit signup_path
        fill_in 'Name', with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_on 'Create my account'
      }.to change(User, :count).by(1)
    end

    describe 'after redirect page' do
      before do
        visit signup_path
        fill_in 'Name', with: 'Example User'
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_on 'Create my account'
      end

      it_behaves_like 'should not have any error messages'
      it_behaves_like 'should redirect root page'
    end
  end

  context 'when signup invalid information' do
    it 'should not increase user count' do
      expect {
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Password confirmation', with: 'bar'
        click_on 'Create my account'
      }.to change(User, :count).by(0)
    end

    describe 'after redirect page' do
      before do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invalid'
        fill_in 'Password', with: 'foo'
        fill_in 'Password confirmation', with: 'bar'
        click_on 'Create my account'
      end

      it 'should have error messages' do
        is_expected.to have_selector('div#error_explanation > ul > li', text: "Name can't be blank")
        is_expected.to have_selector('div#error_explanation > ul > li', text: 'Email is invalid')
        is_expected.to have_selector('div#error_explanation > ul > li', text: "Password confirmation doesn't match Password")
        is_expected.to have_selector('div#error_explanation > ul > li', text: 'Password is too short (minimum is 6 characters)')
      end

      it_behaves_like 'should redirect signup page'
    end
  end

  context 'when activate with valid token' do
    let(:user) { create(:user, activated: false) }

    before do
      visit edit_account_activation_path(user.activation_token, email: user.email)
    end

    subject { page }

    it_behaves_like 'should state login'
    it_behaves_like 'should redirect user page'
    it { is_expected.to have_text 'Account activated!' }
  end

  context 'when activate with invalid token' do
    let(:user) { create(:user, activated: false) }

    before do
      visit edit_account_activation_path('invalid token', email: user.email)
    end

    subject { page }

    it_behaves_like 'should redirect root page'
    it { is_expected.to have_text 'Invalid activation link' }
  end

  context 'when login with activated user' do
    let(:user) { create(:user, activated: true) }

    before { log_in_as(user) }

    it_behaves_like 'should state login'
    it_behaves_like 'should redirect user page'
  end

  context 'when login with non-activated user' do
    let(:user) { create(:user, activated: false) }

    before { log_in_as(user) }

    it_behaves_like 'should redirect root page'
    it_behaves_like 'should state not login'
  end
end
