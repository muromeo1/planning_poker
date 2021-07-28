require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
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

  describe 'POST /users' do
    before do
      post '/api/v1/users', params: params
    end

    it { expect(parsed_response['token']).to be_present }
  end

  describe 'GET /users/login' do
    let(:user) { create(:user) }
    let(:params) { { email: user.email, password: user.password } }

    before do
      get '/api/v1/users/login', params: params
    end

    it { expect(parsed_response['token']).to be_present }
  end
end
