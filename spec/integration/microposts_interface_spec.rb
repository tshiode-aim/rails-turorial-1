require 'rails_helper'
require 'spec_helper'

describe 'microposts interface', type: :feature do
  subject { page }

  let(:user) { create(:user) }

  context 'when create micropost' do
    before do
      log_in_as(user)
      visit root_path
      fill_in 'micropost_content', with: content
      attach_file('micropost_picture', 'test/fixtures/rails.png')
    end

    context 'with valid content' do
      let(:content) { 'Hey!' }

      it 'should increase microposts' do
        expect { click_button 'Post' }.to change(Micropost, :count).by(1)
      end

      it 'should exist picture in micropost' do
        click_button 'Post'
        expect(subject.body).to be_include('rails.png')
      end
    end

    context 'with content empty' do
      let(:content) { '' }

      it 'should have error messages' do
        click_button 'Post'
        is_expected.to have_selector('div#error_explanation')
      end
    end
  end

  context 'when delete micropost' do
    before do
      create(:micropost, user: user)
      log_in_as(user)
      visit root_path
    end

    it 'should decrease microposts' do
      expect { click_link 'delete' }.to change(Micropost, :count).by(-1)
    end
  end

  context 'when visit other user profile' do
    before do
      create(:micropost, user: other_user)
      log_in_as(user)
      visit user_path(other_user)
    end

    let(:other_user) { create(:user) }

    it 'should not find delete links' do
      is_expected.to have_no_selector('a', text: 'delete')
    end
  end

  context 'when visit user profile' do
    before do
      create_list(:micropost, number_of_microposts, user: user)
      log_in_as(user)
      visit root_path
    end

    context 'with a lot of micropost' do
      let(:number_of_microposts) { 50 }

      it 'should have microposts count' do
        is_expected.to have_selector('span', text: '50 microposts')
      end
    end

    context 'with no microposts' do
      let(:number_of_microposts) { 0 }

      it 'should have microposts count' do
        is_expected.to have_selector('span', text: '0 microposts')
      end
    end

    context 'with a micropost' do
      let(:number_of_microposts) { 1 }
      it 'should have microposts count' do
        is_expected.to have_selector('span', text: '1 micropost')
        is_expected.to have_no_selector('span', text: '1 microposts')
      end
    end
  end
end
