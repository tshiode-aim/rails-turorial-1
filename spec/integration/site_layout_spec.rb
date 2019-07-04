require 'rails_helper'
require 'spec_helper'

describe 'layout links', type: :feature do
  include ApplicationHelper
  subject { page }

  context 'when visit home page' do
    before { visit root_path }

    it 'should have 2 links to root_path' do
      is_expected.to have_selector("a[href='#{root_path}']", count: 2)
    end

    it 'should have a link to help_path' do
      is_expected.to have_selector("a[href='#{help_path}']")
    end

    it 'should have a link to about_path' do
      is_expected.to have_selector("a[href='#{about_path}']")
    end

    it 'should have a link to contact_path' do
      is_expected.to have_selector("a[href='#{contact_path}']")
    end
  end

  context 'when visit contact page' do
    before { visit contact_path }

    it 'should have a word "Contact" in the title' do
      is_expected.to have_selector('title', text: full_title('Contact'), visible: false)
    end
  end
end
