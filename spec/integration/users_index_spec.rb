require 'rails_helper'
require 'spec_helper'

describe 'users index', type: :feature do
  subject { page }

  let(:admin) { create(:michael) }
  let(:non_admin) { create(:archer) }

  before 'create many users' do
    30.times do |n|
      create(:archer, name: n, email: "example#{n}@example.com")
    end
  end

  context 'when visit index page as admin' do
    before do
      log_in_as(admin)
      visit users_path
    end

    let(:first_page_of_users) { User.paginate(page: 1) }

    it 'should including pagination and delete links' do
      first_page_of_users.each do |user|
        is_expected.to have_selector("a[href='#{user_path(user)}']", text: user.name)
        is_expected.to have_selector("a[href='#{user_path(user)}']", text: 'delete') unless user == admin
      end
    end

    context 'when delete user' do
      let!(:initial_user_count) { User.count }

      before { click_link('delete', match: :first) }

      it 'should decrease user count' do
        expect(initial_user_count - 1).to eq User.count
      end
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
