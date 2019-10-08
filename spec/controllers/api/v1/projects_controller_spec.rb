require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }

  let(:project) { create(:project, user: user, name: project_name) }
  let(:project_name) { 'suka' }
  let(:params) { { name: project_name } }
  let(:invalid_project_name) { nil }
  let(:payload) { { user_id: user.id } }
  let(:session) { JWTSessions::Session.new(payload: payload) }
  let(:tokens) { session.login }

  before do
    tokens
  end

  describe 'GET #index' do
    before do
      project
    end

    it 'returns a success response' do
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      get :index
      expect(response).to be_successful
      expect(response_json.size).to eq 1
      expect(response_json.first['id']).to eq project.id
    end

    it 'unauth without cookie' do
      get :index
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Todo' do
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
        expect do
          post :create, params: { project: params }
        end.to change(Project, :count).by(1)
      end

      it 'renders a JSON response with the new todo' do
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
        post :create, params: params
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/vnd.api+json')
      end

      it 'unauth without CSRF' do
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        post :create, params: params
        expect(response).to have_http_status(401)
      end
    end

    context 'with invalid params' do
      let(:project_name) { invalid_project_name }

      it 'renders a JSON response with errors for the new todo' do
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
        post :create, params: params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    before do
      project
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      request.headers[JWTSessions.csrf_header] = tokens[:csrf]
      put :update, params: { id: project.id, project: params }
    end

    context 'with valid params' do
      let(:project_name) { 'new_name' }

      it 'updates the requested todo' do
        project.reload
        expect(project.name).to eq project_name
      end

      it 'renders a JSON response with the todo' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      let(:project_name) { invalid_project_name }

      it 'renders a JSON response with errors for the todo' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      project
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      request.headers[JWTSessions.csrf_header] = tokens[:csrf]
    end

    it 'destroys the requested todo' do
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      request.headers[JWTSessions.csrf_header] = tokens[:csrf]
      expect do
        delete :destroy, params: project.id
      end.to change(Project, :count).by(-1)
    end
  end
end
