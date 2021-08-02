require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  subject(:controller) do
    request, route = self.class.description.split
    send(request, route, params: params)
  end

  let(:random_pass) { Faker::Internet.password }
  let(:parsed_response) { JSON.parse(response.body) }
  let(:params) do
    {
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: random_pass,
      password_confirmation: random_pass
    }.as_json
  end

  before do
    controller
  end

  describe 'post /api/v1/users' do
    it { expect(parsed_response['token']).to be_present }
  end

  describe 'get /api/v1/users/authenticate' do
    let(:user) { create(:user) }
    let(:params) { { email: user.email, password: user.password } }

    it { expect(parsed_response['token']).to be_present }
  end
end
