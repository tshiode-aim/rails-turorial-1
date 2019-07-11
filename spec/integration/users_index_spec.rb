require 'rails_helper'
require 'spec_helper'

describe 'users index', type: :feature do
  subject { page }

  let!(:admin_user) { create(:user, :admin) }
  let!(:non_admin_user) { create(:user, :non_admin) }
  let!(:other_users) { create_list(:user, 10, admin: true) + create_list(:user, 10, admin: false) }
  let!(:all_users) { other_users + [admin_user] + [non_admin_user] }
  let!(:non_activated_user) { create(:user, activated: false) }

  context 'when visit index page as admin' do
    before do
      log_in_as(admin_user)
      visit users_path
    end

    it '全てのユーザはユーザページへのリンクがあること' do
      all_users.each do |user|
        is_expected.to have_selector("a[href='#{user_path(user)}']", text: user.name)
      end
    end

    it '自分はdeleteリンクがないこと' do
      is_expected.to have_no_selector("a[href='#{user_path(admin_user)}']", text: 'delete')
    end

    it '自分以外のユーザにはdeleteリンクがあること' do
      other_users.each do |user|
        is_expected.to have_selector("a[href='#{user_path(user)}']", text: 'delete')
      end
    end

    it 'should not visible non-activated user' do
      is_expected.to have_no_selector("a[href='#{user_path(non_activated_user)}']")
    end
  end

  context 'when delete user' do
    before do
      log_in_as(admin_user)
      visit users_path
    end

    it 'should decrease user count' do
      expect { click_link('delete', match: :first) }.to change(User, :count).by(-1)
    end
  end

  context 'when visit index page as non-admin' do
    before do
      log_in_as(non_admin_user)
      visit users_path
    end

    it 'should not exsits any delete links' do
      is_expected.to have_no_selector('a', text: 'delete')
    end
  end
end
