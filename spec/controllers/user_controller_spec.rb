require 'rails_helper'
require 'spec_helper'

describe UsersController, type: :feature do
  subject { page }

  context 'when visit signup page' do
    before { visit signup_path }

    it_should_behave_like 'should response code 200'
  end
end
