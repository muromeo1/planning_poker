require 'rails_helper'

RSpec.describe Sessions::AuthorizeToken, type: :interactor do
  describe '.call' do
    subject(:interactor) { described_class.call(params) }

    let(:params) { {} }
    let(:user) { create(:user) }
    let(:headers) do
      {
        'Authorization' => JsonWebToken.encode({ user_id: user.id })
      }
    end

    before do
      Rails.application.secrets.secret_key_base = '123'
    end

    context 'When token is present' do
      let(:params) { headers }

      it { expect(interactor).to be_a_success }
      it { expect(interactor.user).to eq(user) }
    end

    context 'When token is invalid' do
      let(:params) { { 'Authorization' => 'oops' } }

      it { expect(interactor).to be_a_failure }
      it { expect(interactor.error).to eq('Invalid token') }
    end
  end
end
