require 'rails_helper'

RSpec.describe ::User::Authenticate, type: :interactor do
  describe '.call' do
    subject(:interactor) { described_class.call(params) }

    let(:user) { create(:user) }
    let(:params) { {} }

    context 'When has correct credentials' do
      let(:params) { { email: user.email, password: user.password } }

      it { expect(interactor).to be_a_success }
      it { expect(interactor.token).to be_present }
    end
  end
end
