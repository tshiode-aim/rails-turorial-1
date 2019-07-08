require 'rails_helper'
require 'spec_helper'

describe SessionsController, type: :feature do
  subject { page }

  context 'when visit login page' do
    before { visit login_path }

    it_should_behave_like 'should response code 200'
  end
end
