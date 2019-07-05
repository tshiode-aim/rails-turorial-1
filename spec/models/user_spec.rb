require 'rails_helper'
require 'spec_helper'

describe User, type: :model do
  describe 'validation' do
    let(:user) { build(:user) }
    subject { user }

    it 'should accept valid user' do
      is_expected.to be_valid
    end

    context 'when name is only space' do
      before { user.name = ' ' }

      it { is_expected.to be_invalid }
    end

    context 'when name over 50 characters' do
      before { user.name = 'a' * 51 }

      it { is_expected.to be_invalid }
    end

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
      before { user.email = ' ' }

      it { is_expected.to be_invalid }
    end

    context 'when email is over 255 characters' do
      before { user.email = 'a' * 244 + '@example.com' }

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
      before do
        @duplicate_user = user.dup
        user.save
        @duplicate_user.email = user.email.upcase
      end

      it 'same email user should be reject' do
        expect(@duplicate_user).to be_invalid
      end
    end

    context 'when email with mixed case' do
      let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }
      before { user.update_attributes(email: mixed_case_email) }

      it 'should email read from the database is lower case' do
        expect(mixed_case_email.downcase).to eq user.reload.email
      end
    end

    context 'when password is only space' do
      before { user.password = user.password_confirmation = ' ' * 6 }

      it { is_expected.to be_invalid }
    end

    context 'when password is less than 6 characters' do
      before { user.password = user.password_confirmation = 'a' * 5 }

      it { is_expected.to be_invalid }
    end
  end
end
