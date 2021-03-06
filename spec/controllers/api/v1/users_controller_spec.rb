require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST#login' do
    let(:email) { user.email }
    let(:password) { user.password }
    let(:params) { { email: email, password: password } }
    let(:request) { post :login, params: params }

    before do
      request
    end

    context 'email does not exist' do
      let(:email) { 'ihateyou@mail.com' }

      it 'returns 422' do
        expect_status '422'
        expect_json('errors.0.title', 'User')
        expect_json('errors.0.detail', 'fucking shit')
      end
    end

    context 'invalid password' do
      let(:password) { 'FuckYouAgain1' }

      it 'returns 422' do
        expect_status '422'
        expect_json('errors.0.title', 'User')
        expect_json('errors.0.detail', 'fucking shit')
      end
    end

    context 'valid credentials' do
      it 'logins user' do
        expect_status '201'
        expect(response.headers['Authorization']).to be_present
        expect_json('data.id', user.id.to_s)
        expect_json('data.type', 'users')
        expect_json('data.attributes.email', user.email)
        expect_json('data.attributes.first_name', user.first_name)
        expect_json('data.attributes.last_name', user.last_name)
      end
    end
  end

  describe 'POST#create' do
    let(:password) { user.password }
    let(:email) { user.email }
    let(:password_confirmation) { password }
    let(:params) do
      {
        email: email,
        password: password,
        password_confirmation: password_confirmation
      }
    end
    let(:request) { post :create, params: params }

    context 'email already exists' do
      it 'returns 422' do
        request
        expect_status '422'
        expect_json('errors.0.title', 'Email')
        expect_json('errors.0.detail', 'such email already exists')
      end
    end

    context 'invalid password confirmation' do
      let(:password_confirmation) { 'FuckYouAgain1' }

      it 'returns 422' do
        request
        expect_status '422'
        expect_json('errors.0.title', 'Password confirmation')
        expect_json('errors.0.detail', 'must be equal to DirtyBitch1')
      end
    end

    context 'valid credentials' do
      let(:email) { 'learnenglish@mail.com' }

      it 'creates User' do
        user
        expect { request }.to change { User.count }.by(1)
        expect_status 201
        expect(response.headers['Authorization']).to be_present
        user = User.last
        expect_json('data.id', user.id.to_s)
        expect_json('data.type', 'users')
        expect_json('data.attributes.email', user.email)
        expect_json('data.attributes.first_name', user.first_name)
        expect_json('data.attributes.last_name', user.last_name)
      end
    end
  end
end
