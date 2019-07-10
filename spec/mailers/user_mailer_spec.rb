require 'rails_helper'
require 'spec_helper'

describe UserMailer do
  context 'when send activation mail' do
    let(:user) { create(:user) }
    let(:activation_mail) { described_class.account_activation(user) }
    let(:email_subject) { 'Account activation' }
    let(:email_to) { [user.email] }
    let(:email_from) { ['noreply@example.com'] }

    it { expect(activation_mail.subject).to eq email_subject }
    it { expect(activation_mail.to).to eq email_to }
    it { expect(activation_mail.from).to eq email_from }

    subject { activation_mail.body.encoded }
    it { is_expected.to be_include(user.name) }
    it { is_expected.to be_include(user.activation_token) }
    it { is_expected.to be_include(CGI.escape(user.email)) }
  end
end
