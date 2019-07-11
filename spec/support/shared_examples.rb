## HTTP Response

shared_examples_for 'should response code 200' do
  it { is_expected.to have_http_status 200 }
end

## Redirect

shared_examples_for 'should redirect visitors root page' do
  it { is_expected.to have_selector('h1', text: 'Welcome to the Sample App') }
end

shared_examples_for 'should redirect members root page' do
  it { is_expected.to have_selector('a', text: 'view my profile') }
end

shared_examples_for 'should redirect login page' do
  it { is_expected.to have_selector("form[action='#{login_path}']") }
end

shared_examples_for 'should not redirect login page' do
  it { is_expected.to have_no_selector("form[action='#{login_path}']") }
end

shared_examples_for 'should redirect user page' do
  it { is_expected.to have_selector('section.user_info') }
end

shared_examples_for 'should not redirect user page' do
  it { is_expected.to have_no_selector('section.user_info') }
end

shared_examples_for 'should redirect edit page' do
  it { is_expected.to have_selector("form[action='#{user_path(user)}']") }
end

shared_examples_for 'should redirect signup page' do
  it { is_expected.to have_selector('form[action="/signup"]') }
end

# Login State

shared_examples_for 'should state login' do
  it { is_expected.to have_selector("a[href='#{logout_path}']", text: 'Log out') }
end

shared_examples_for 'should state not login' do
  it { is_expected.to have_selector("a[href='#{login_path}']", text: 'Log in') }
end

## Error messages

shared_examples_for 'should have any error messages' do
  it { is_expected.to have_selector('div.alert.alert-danger') }
end

shared_examples_for 'should not have any error messages' do
  it { is_expected.to have_no_selector('div.alert.alert-danger') }
end
