require 'rails_helper'
require 'spec_helper'

describe 'password resets', type: :feature do
  let(:user) { create(:user) }

  context 'when request reset password' do
    subject { page }

    before do
      visit new_password_reset_path
      fill_in 'Email', with: email
      click_button 'Submit'
    end

    context 'with valid email' do
      let(:email) { user.email }

      it 'should success request' do
        is_expected.to have_text 'Email sent with password reset instructions'
      end
    end

    context 'with invalid email' do
      let(:email) { '' }

      it 'should fail request' do
        is_expected.to have_text 'Email address not found'
      end
    end
  end

  context 'when visit reset password' do
    subject { page }

    before do
      user.create_reset_digest
      visit edit_password_reset_path(token, email: email)
    end

    let(:email) { user.email }
    let(:token) { user.reset_token }

    context 'with valid information' do
      it 'should view reset password page' do
        is_expected.to have_text 'Reset password'
      end
    end

    context 'with invalid email' do
      let(:email) { '' }

      it_behaves_like 'should redirect root page'
    end

    context 'with not-activated user' do
      let(:user) { create(:user, activated: false) }

      it_behaves_like 'should redirect root page'
    end

    context 'with invalid token' do
      let(:token) { 'wrong token' }

      it_behaves_like 'should redirect root page'
    end
  end

  context 'when execute reset password' do
    subject { page }

    before do
      user.create_reset_digest
      visit edit_password_reset_path(user.reset_token, email: user.email)
      user.update(reset_sent_at: reset_sent_at)
      fill_in 'Password', with: password
      fill_in 'Confirmation', with: password_confirmation
      click_button 'Update password'
    end

    let(:reset_sent_at) { Time.zone.now }

    context 'with valid password' do
      let(:password) { 'changed_password' }
      let(:password_confirmation) { 'changed_password' }

      it 'should view success message' do
        is_expected.to have_text 'Password has been reset.'
      end
      it_behaves_like 'should state login'
    end

    context 'with invalid password confirmation' do
      let(:password) { 'changed_password' }
      let(:password_confirmation) { 'another_password' }

      it_behaves_like 'should have any error messages'
    end

    context 'with empty password' do
      let(:password) { '' }
      let(:password_confirmation) { '' }

      it_behaves_like 'should have any error messages'
    end

    context 'with expired token' do
      let(:password) { 'changed_password' }
      let(:password_confirmation) { 'changed_password' }
      let(:reset_sent_at) { 3.hours.ago }

      it_behaves_like 'should have any error messages'
    end
  end
end
