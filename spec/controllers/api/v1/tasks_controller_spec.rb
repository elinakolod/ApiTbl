require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:new_name) { 'new name' }
  let(:params) { { name: new_name, project_id: project.id } }
  let(:payload) { { user_id: user.id } }
  let(:session) { JWTSessions::Session.new(payload: payload) }
  let(:tokens) { session.login }

  before do
    project
    tokens
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new task' do
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
        expect do
          post :create, params: params
        end.to change(Task, :count).by(1)
        expect(Task.last.project_id).to eq(project.id)
      end

      it 'renders a JSON response with the new task' do
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
      let(:new_name) { nil }

      it 'renders a JSON response with errors for the new task' do
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
      task
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      request.headers[JWTSessions.csrf_header] = tokens[:csrf]
      put :update, params: { id: task.id, name: new_name, done: true }
    end

    context 'with valid params' do
      it 'updates the requested task' do
        task.reload
        expect(task.name).to eq(new_name)
      end

      it 'renders a JSON response with the task' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/vnd.api+json')
      end
    end

    context 'with invalid params' do
      let(:new_name) { nil }

      it 'renders a JSON response with errors for the task' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      task
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      request.headers[JWTSessions.csrf_header] = tokens[:csrf]
    end

    it 'destroys the requested task' do
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      request.headers[JWTSessions.csrf_header] = tokens[:csrf]
      expect do
        delete :destroy, params: { id: task.id }
      end.to change(Task, :count).by(-1)
    end
  end
end
