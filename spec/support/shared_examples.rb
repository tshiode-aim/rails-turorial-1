## HTTP Response

shared_examples_for 'should response code 200' do
  it { is_expected.to have_http_status 200 }
end

## Redirect

shared_examples_for 'should redirect root page' do
  it { is_expected.to have_selector('h1', text: 'Welcome to the Sample App') }
end

shared_examples_for 'should redirect login page' do
  it { is_expected.to have_selector("form[action='#{login_path}']") }
end

shared_examples_for 'should not redirect login page' do
  it { is_expected.to have_no_selector("form[action='#{login_path}']") }
end

shared_examples_for 'should redirect user page' do
  it { is_expected.to have_selector('section.user_info') }
  it { is_expected.to have_selector("a[href='#{logout_path}']") }
  it { is_expected.to have_selector("a[href='#{user_path(user)}']") }
end

shared_examples_for 'should not redirect user page' do
  it { is_expected.to have_no_selector('section.user_info') }
  it { is_expected.to have_no_selector("a[href='#{logout_path}']") }
  it { is_expected.to have_no_selector("a[href='#{user_path(user)}']") }
end

shared_examples_for 'should redirect edit page' do
  it { is_expected.to have_selector("form[action='#{user_path(user)}']") }
end

shared_examples_for 'should redirect signup page' do
  it { is_expected.to have_selector('form[action="/signup"]') }
end

## Error messages

shared_examples_for 'should have any error messages' do
  it { is_expected.to have_selector('div.alert.alert-danger') }
end

shared_examples_for 'should not have any error messages' do
  it { is_expected.to have_no_selector('div.alert.alert-danger') }
end
