require 'rails_helper'
require 'spec_helper'

describe Relationship, type: :model do
  let(:relationship) { build(:relationship, follower: follower, followed: followed) }
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }

  subject { relationship }

  context 'when correct all information' do
    it { is_expected.to be_valid }
  end

  context 'when follower is nil' do
    let(:follower) { nil }

    it { is_expected.to be_invalid }
  end

  context 'when followed is nil' do
    let(:followed) { nil }

    it { is_expected.to be_invalid }
  end
end
