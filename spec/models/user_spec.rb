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
end
