require 'rails_helper'

RSpec.describe User::Create, type: :interactor do
  describe '.call' do
    subject(:interactor) { described_class.call(params) }

    let(:params) { {} }
    let(:random_pass) { Faker::Internet.password }
    let(:correct_params) do
      {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: random_pass,
        password_confirmation: random_pass
      }
    end

    context 'When i pass correct params' do
      let(:params) { correct_params }

      it { expect(interactor.user.email).to eq(correct_params[:email]) }
      it { expect(interactor.token).to be_present }
    end
  end
end
