shared_context 'login_with_current_user' do
  let(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end
