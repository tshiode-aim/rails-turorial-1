require 'rails_helper'
require 'spec_helper'

describe User, type: :model do
  describe 'validation' do
    let(:user) { build(:user, name: name, email: email, password: password, password_confirmation: password) }
    let(:name) { 'Example User' }
    let(:email) { 'user@example.com' }
    let(:password) { 'foobar' }

    subject { user }

    context 'when user all parameter valid' do
      it { is_expected.to be_valid }
    end

    describe 'name' do
      context 'when name is only space' do
        let(:name) { ' ' }

        it { is_expected.to be_invalid }
      end

      context 'when name over 50 characters' do
        let(:name) { 'a' * 51 }

        it { is_expected.to be_invalid }
      end
    end

    describe 'email' do
      context 'when email valid format' do
        let(:valid_addresses) do
          %w(
            user@example.com
            USER@foo.COM A_US-ER@foo.bar.org
            first.last@foo.jp
            alice+bob@baz.cn
          )
        end

        it 'should accept all' do
          valid_addresses.each do |valid_address|
            user.email = valid_address
            is_expected.to be_valid
          end
        end
      end

      context 'when email is only space' do
        let(:email) { ' ' }

        it { is_expected.to be_invalid }
      end

      context 'when email is over 255 characters' do
        let(:email) { 'a' * 244 + '@example.com' }

        it { is_expected.to be_invalid }
      end

      context 'when email invalid format' do
        let(:invalid_addresses) do
          %w(
            user@example,com
            user_at_foo.org
            user.name@example.
            foo_@bar_baz.com
            foo@bar+baz.com
            hoge@example..com
          )
        end

        it 'should reject all' do
          invalid_addresses.each do |invalid_address|
            user.email = invalid_address
            is_expected.to be_invalid
          end
        end
      end

      context 'when same email' do
        before { create(:user, email: email, name: 'Other User') }

        it { is_expected.to be_invalid }
      end

      context 'when email with mixed case' do
        let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }
        let(:email) { mixed_case_email }

        before { user.save }

        it 'should email read from the database is lower case' do
          expect(mixed_case_email.downcase).to eq user.reload.email
        end
      end
    end

    describe 'password' do
      context 'when password is only space' do
        let(:password) { ' ' * 6 }

        it { is_expected.to be_invalid }
      end

      context 'when password is less than 6 characters' do
        let(:password) { 'a' * 5 }

        it { is_expected.to be_invalid }
      end
    end
  end

  describe 'association' do
    context 'when destroy user which has microposts' do
      before { user.microposts.create!(content: 'Hey!') }

      let(:user) { create(:user) }

      it 'should be destroyed microposts with user' do
        expect { user.destroy }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe '#authenticated?' do
    context 'when digest is nil' do
      let(:user) { create(:user) }

      subject { user.authenticated?(:remember, '') }

      it { is_expected.to be_falsey }
    end
  end

  describe '#follow' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context 'when user follow other_user' do
      subject { user.follow(other_user) }

      it 'should increase following count' do
        expect { subject }.to change(user.following, :count).by(1)
      end
    end
  end

  describe '#unfollow' do
    before { user.follow(other_user) }

    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context 'when user unfollow other_user' do
      subject { user.unfollow(other_user) }

      it 'should decrease following count' do
        expect { subject }.to change(user.following, :count).by(-1)
      end
    end
  end

  describe '#following?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    subject { user }

    context 'when user following other_user' do
      before { user.follow(other_user) }

      it { is_expected.to be_following(other_user) }
    end

    context 'when user not following other_user' do
      it { is_expected.to_not be_following(other_user) }
    end
  end

  describe '#feed' do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }
    let(:non_followed_user) { create(:user) }

    before do
      create_list(:micropost, 10, user: user)
      create_list(:micropost, 10, user: followed_user)
      create_list(:micropost, 10, user: non_followed_user)
    end

    subject { user.feed }

    context 'when user following other_user' do
      before { user.follow(followed_user) }

      it 'should include self posts' do
        user.microposts.each do |micropost|
          is_expected.to be_include(micropost)
        end
      end

      it 'should include other_user posts' do
        followed_user.microposts.each do |micropost|
          is_expected.to be_include(micropost)
        end
      end

      it 'should not include user3 posts' do
        non_followed_user.microposts.each do |micropost|
          is_expected.to_not be_include(micropost)
        end
      end
    end
  end
end
