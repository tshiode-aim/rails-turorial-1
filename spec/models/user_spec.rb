require 'rails_helper'
require 'spec_helper'

describe User, type: :model do
  describe 'validation' do
    before do
      @user = User.new(
        name: 'Example User',
        email: 'user@example.com',
        password: 'foobar',
        password_confirmation: 'foobar'
      )
    end
    subject { @user }

    it 'should accept valid user' do
      is_expected.to be_valid
    end

    describe 'name' do
      it 'should reject only space' do
        @user.name = ' '
        is_expected.to be_invalid
      end

      it 'should reject over 50 characters' do
        @user.name = 'a' * 51
        is_expected.to be_invalid
      end
    end

    describe 'email' do
      it 'should accept valid format' do
        valid_addresses = %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn)
        valid_addresses.each do |valid_address|
          @user.email = valid_address
          is_expected.to be_valid
        end
      end

      it 'should reject only space' do
        @user.email = ' '
        is_expected.to be_invalid
      end

      it 'should reject over 255 characters' do
        @user.email = 'a' * 244 + '@example.com'
        is_expected.to be_invalid
      end

      it 'should reject invalid format' do
        invalid_addresses = %w(user@example,com user_at_foo.org user.name@example. foo_@bar_baz.com foo@bar+baz.com hoge@example..com)
        invalid_addresses.each do |invalid_address|
          @user.email = invalid_address
          is_expected.to be_invalid
        end
      end

      it 'should be unique' do
        duplicate_user = @user.dup
        @user.save
        duplicate_user.email = @user.email.upcase
        expect(duplicate_user).to be_invalid
      end

      it 'should be saved as lower-case' do
        mixed_case_email = 'Foo@ExAMPle.CoM'
        @user.email = mixed_case_email
        @user.save
        expect(mixed_case_email.downcase).to eq @user.reload.email
      end
    end

    describe 'password' do
      it 'should reject only space' do
        @user.password = @user.password_confirmation = ' ' * 6
        is_expected.to be_invalid
      end

      it 'should reject less than 6 characters' do
        @user.password = @user.password_confirmation = 'a' * 5
        is_expected.to be_invalid
      end
    end
  end
end
