require 'rails_helper'
require 'spec_helper'

describe 'users login', type: :feature do
  subject { page }

  let(:user) { create(:user) }

  context 'when login with valid information' do
    before { log_in_as(user) }

    it_behaves_like 'should state login'
    it_behaves_like 'should redirect user page'
    it_behaves_like 'should not redirect login page'
  end

  context 'when login with invalid information' do
    before { log_in_as(user, password: '') }

    it_behaves_like 'should redirect login page'
    it_behaves_like 'should have any error messages'

    context 'when visit another page' do
      before { visit root_path }

      it_behaves_like 'should not have any error messages'
    end
  end

  context 'when logout after login' do
    before do
      log_in_as(user)
      logout
    end

    it_behaves_like 'should state not login'
    it_behaves_like 'should redirect root page'
    it_behaves_like 'should not redirect user page'
  end

  context 'when logout after logout' do
    before do
      log_in_as(user)
      logout
      force_logout
    end

    it_behaves_like 'should state not login'
    it_behaves_like 'should redirect root page'
    it_behaves_like 'should not redirect user page'
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
