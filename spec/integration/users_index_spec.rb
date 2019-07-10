require 'rails_helper'
require 'spec_helper'

describe 'users index', type: :feature do
  subject { page }

  let(:admin) { create(:user, :admin) }
  let(:non_admin) { create(:user, :non_admin) }

  let(:first_page_of_users) { User.paginate(page: 1) }
  let(:first_page_of_admin_users) { first_page_of_users.select(&:admin?) }
  let(:first_page_of_non_admin_users) { first_page_of_users.reject(&:admin?) }

  before 'create many users' do
    30.times do |n|
      create(:user, name: n, email: "example#{n}@example.com")
    end
  end

  context 'when visit index page as admin' do
    before do
      log_in_as(admin)
      visit users_path
    end

    it '全てのユーザはユーザページへのリンクがあること' do
      first_page_of_users.each do |user|
        is_expected.to have_selector("a[href='#{user_path(user)}']", text: user.name)
      end
    end

    it '管理者であるユーザにはdeleteリンクがないこと' do
      first_page_of_admin_users.each do |user|
        is_expected.to have_no_selector("a[href='#{user_path(user)}']", text: 'delete')
      end
    end

    it '管理者ではないユーザにはdeleteリンクがあること' do
      first_page_of_non_admin_users.each do |user|
        is_expected.to have_selector("a[href='#{user_path(user)}']", text: 'delete')
      end
    end
  end

  context 'when delete user' do
    before do
      log_in_as(admin)
      visit users_path
    end

    it 'should decrease user count' do
      expect { click_link('delete', match: :first) }.to change(User, :count).by(-1)
    end
  end

  context 'when visit index page as non-admin' do
    before do
      log_in_as(non_admin)
      visit users_path
    end

    it 'should not exsits any delete links' do
      is_expected.to have_no_selector('a', text: 'delete')
    end
  end
end
