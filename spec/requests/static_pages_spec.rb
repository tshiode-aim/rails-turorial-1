
require 'rails_helper'
require 'spec_helper'

describe 'visit Static pages', type: :feature do
  subject { page }
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  shared_examples_for 'should response code 200' do
    it { is_expected.to have_http_status 200 }
  end

  context 'when access to root_url' do
    before { visit root_url }

    it_should_behave_like 'should response code 200'
    it 'should have a word "Home" in the title' do
      is_expected.to have_selector('title', text: "#{base_title}", visible: false)
    end
  end

  context 'when access to static_pages_home_url' do
    before { visit static_pages_home_url }

    it_should_behave_like 'should response code 200'
    it 'should have a word "Home" in the title' do
      is_expected.to have_selector('title', text: "#{base_title}", visible: false)
    end
  end

  context 'when access to statis_pages_help_url' do
    before { visit static_pages_help_url }

    it_should_behave_like 'should response code 200'
    it 'should have a word "Help" in the title' do
      is_expected.to have_selector('title', text: "Help | #{base_title}", visible: false)
    end
  end

  context 'when access to statis_pages_about_url' do
    before { visit static_pages_about_url }

    it_should_behave_like 'should response code 200'
    it 'should have a word "About" in the title' do
      is_expected.to have_selector('title', text: "About | #{base_title}", visible: false)
    end
  end

  context 'when access to statis_pages_contact_url' do
    before { visit static_pages_contact_url }

    it_should_behave_like 'should response code 200'
    it 'should have a word "Contact" in the title' do
      is_expected.to have_selector('title', text: "Contact | #{base_title}", visible: false)
    end
  end
end
