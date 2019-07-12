require 'rails_helper'
require 'spec_helper'

describe 'users profile', type: :feature do
  include ApplicationHelper

  subject { page }

  context 'when visit users profile' do
    before do
      create_list(:micropost, microposts_count, user: user)
      visit user_path(user)
    end

    let(:user) { create(:user) }

    context 'with few microposts' do
      let(:microposts_count) { 10 }

      it 'should title include user name' do
        is_expected.to have_selector('title', text: full_title(user.name), visible: false)
      end

      it 'should have user name in h1 tag' do
        is_expected.to have_selector('h1', text: user.name)
      end

      it 'should have gravatar' do
        is_expected.to have_selector('h1 > img.gravatar')
      end

      describe 'verification html body' do
        subject { page.body }
        it 'should view count of user microposts' do
          is_expected.to be_include user.microposts.count.to_s
        end

        it 'should view all microposts of user' do
          user.microposts.each do |micropost|
            is_expected.to be_include micropost.content
          end
        end
      end
    end

    context 'with many microposts' do
      let(:microposts_count) { 100 }

      it 'should have pagination' do
        is_expected.to have_selector('div.pagination', count: 1)
      end
    end
  end
end
