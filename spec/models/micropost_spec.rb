require 'rails_helper'
require 'spec_helper'

describe User, type: :model do
  subject { micropost }

  let(:user) { create(:user) }
  let(:micropost) { build(:micropost, user_id: user_id, content: content) }
  let(:user_id) { user.id }
  let(:content) { 'Hey! This is micropost.' }

  context 'when all information corret' do
    it { is_expected.to be_valid }
  end

  context 'when user_id is nil' do
    let(:user_id) { nil }

    it { is_expected.to be_invalid }
  end

  context 'when content is only space' do
    let(:content) { '   ' }

    it { is_expected.to be_invalid }
  end

  context 'when content is over 140 characters' do
    let(:content) { 'a' * 141 }

    it { is_expected.to be_invalid }
  end

  context 'when has many microposts' do
    before do
      create(:micropost, created_at: 1.hour.ago)
      most_recent.save
      create(:micropost, created_at: 2.hours.ago)
    end

    let(:most_recent) { build(:micropost, user_id: user.id, created_at: Time.zone.now) }

    it 'should be order most recent first' do
      expect(most_recent).to eq Micropost.first
    end
  end
end
