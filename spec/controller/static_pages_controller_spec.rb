require 'rails_helper'

describe StaticPagesController, type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  it 'expect get root' do
    get root_url
    expect(response).to have_http_status 200
  end

  it 'expect get home' do
    get static_pages_home_url
    expect(response).to have_http_status 200
    assert_select 'title', "Home | #{base_title}"
  end

  it 'expect get help' do
    get static_pages_help_url
    expect(response).to have_http_status 200
    assert_select 'title', "Help | #{base_title}"
  end

  it 'expect get about' do
    get static_pages_about_url
    expect(response).to have_http_status 200
    assert_select 'title', "About | #{base_title}"
  end

  it 'expect get contact' do
    get static_pages_contact_url
    expect(response).to have_http_status 200
    assert_select 'title', "Contact | #{base_title}"
  end
end
