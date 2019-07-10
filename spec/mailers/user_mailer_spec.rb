require 'rails_helper'
require 'spec_helper'

describe UserMailer do
  describe '#account_activation' do
    let(:user) { create(:user) }
    let(:activation_mail) { described_class.account_activation(user) }
    let(:email_subject) { 'Account activation' }
    let(:email_to) { [user.email] }
    let(:email_from) { ['noreply@example.com'] }

    describe 'header' do
      subject { activation_mail }
      it do
        expect(subject.subject).to eq email_subject
        expect(subject.to).to eq email_to
        expect(subject.from).to eq email_from
      end
    end

    describe 'content' do
      subject { activation_mail.body.encoded }
      it do
        is_expected.to be_include(user.name)
        is_expected.to be_include(user.activation_token)
        is_expected.to be_include(CGI.escape(user.email))
      end
    end
  end

  describe '#password_reset' do
    let(:user) { create(:user, :prepare_reset) }
    let(:password_reset_mail) { described_class.password_reset(user) }
    let(:email_subject) { 'Password reset' }
    let(:email_to) { [user.email] }
    let(:email_from) { ['noreply@example.com'] }

    it { expect(password_reset_mail.subject).to eq email_subject }
    it { expect(password_reset_mail.to).to eq email_to }
    it { expect(password_reset_mail.from).to eq email_from }

    subject { password_reset_mail.body.encoded }
    it { is_expected.to be_include(user.reset_token) }
    it { is_expected.to be_include(CGI.escape(user.email)) }
  end

  context 'when send password reset mail' do
    let(:user) { create(:user) }
    let(:password_reset_mail) { described_class.password_reset(user) }
    let(:email_subject) { 'Password reset' }
    let(:email_to) { [user.email] }
    let(:email_from) { ['noreply@example.com'] }

    before { user.reset_token = User.new_token }

    it { expect(password_reset_mail.subject).to eq email_subject }
    it { expect(password_reset_mail.to).to eq email_to }
    it { expect(password_reset_mail.from).to eq email_from }

    subject { password_reset_mail.body.encoded }
    it { is_expected.to be_include(user.reset_token) }
    it { is_expected.to be_include(CGI.escape(user.email)) }
  end
end
