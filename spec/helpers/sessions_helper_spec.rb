require 'rails_helper'
require 'spec_helper'

describe SessionsHelper, type: :helper do
  describe '#current_user' do
    subject { current_user }

    let(:user) { create(:user) }

    context 'when session is nil' do
      context 'with authenticated' do
        before do
          cookies.permanent.signed[:user_id] = user.id
          allow_any_instance_of(User).to receive(:authenticated?).and_return(true)
        end

        it { is_expected.to eq user }
      end

      context 'with not authenticated' do
        before do
          cookies.permanent.signed[:user_id] = user.id
          allow_any_instance_of(User).to receive(:authenticated?).and_return(false)
        end

        it { is_expected.to_not eq user }
      end
    end
  end
end
