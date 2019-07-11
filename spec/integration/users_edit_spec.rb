require 'rails_helper'
require 'spec_helper'

describe 'users login', type: :feature do
  subject { page }

  let(:user) { create(:user, :admin) }
  let(:new_name) { 'Foo Bar' }
  let(:new_email) { 'foo@bar.com' }

  context 'when edit with invalid information' do
    before do
      log_in_as(user)
      visit edit_user_path(user)
      fill_in 'Name', with: ''
      fill_in 'Email', with: 'foo@invalid'
      fill_in 'Password', with: 'foo'
      fill_in 'Password confirmation', with: 'bar'
      click_button 'Save changes'
    end

    it_behaves_like 'should redirect edit page'
  end

  context 'when edit with valid information' do
    before do
      log_in_as(user)
      visit edit_user_path(user)
      fill_in 'Name', with: new_name
      fill_in 'Email', with: new_email
      click_button 'Save changes'
      user.reload
    end

    it_behaves_like 'should redirect user page'
    it_behaves_like 'should not have any error messages'

    it 'should update user information' do
      expect(user.name).to eq new_name
      expect(user.email).to eq new_email
    end
  end

  context 'when edit with friendly forwarding' do
    before do
      visit edit_user_path(user)
      log_in_as(user)
      fill_in 'Name', with: new_name
      fill_in 'Email', with: new_email
      click_button 'Save changes'
      user.reload
    end

    it_behaves_like 'should redirect user page'
    it_behaves_like 'should not have any error messages'

    it 'should update user information' do
      expect(user.name).to eq new_name
      expect(user.email).to eq new_email
    end
  end
end
