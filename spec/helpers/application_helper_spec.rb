require 'rails_helper'
require 'spec_helper'

describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe '#full_title' do
    subject { full_title(page_name) }
    let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

    context 'when take no arguments' do
      it 'should return default title' do
        expect(full_title).to eq base_title
      end
    end

    context 'when take empty arguments' do
      let(:page_name) { '' }

      it 'should return default title' do
        is_expected.to eq base_title
      end
    end

    context 'when take any arguments' do
      let(:page_name) { 'Help' }

      it 'should return title with arguments' do
        is_expected.to eq "Help | #{base_title}"
      end
    end
  end
end
