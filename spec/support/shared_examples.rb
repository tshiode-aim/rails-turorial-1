shared_examples_for 'should response code 200' do
  it { is_expected.to have_http_status 200 }
end
