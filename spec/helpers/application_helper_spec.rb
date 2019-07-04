require 'rails_helper'
require 'spec_helper'

describe 'full_title helper' do
  include ApplicationHelper

  it 'should get title without any arguments' do
    expect(full_title).to eq 'Ruby on Rails Tutorial Sample App'
  end

  it 'should get title with an argument' do
    expect(full_title('Help')).to eq 'Help | Ruby on Rails Tutorial Sample App'
  end
end
