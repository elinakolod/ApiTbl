require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment) { create(:comment, task: task) }
  let(:new_body) { 'new body' }
  let(:params) { { body: new_body, task_id: task.id } }
  let(:payload) { { user_id: user.id } }
  let(:session) { JWTSessions::Session.new(payload: payload) }
  let(:tokens) { session.login }

  before do
    task
    tokens
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new comment' do
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
        expect do
          post :create, params: params
        end.to change(Comment, :count).by(1)
        expect(Comment.last.task_id).to eq(task.id)
      end

      it 'renders a JSON response with the new comment' do
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
      let(:new_body) { nil }

      it 'renders a JSON response with errors for the new comment' do
        request.cookies[JWTSessions.access_cookie] = tokens[:access]
        request.headers[JWTSessions.csrf_header] = tokens[:csrf]
        post :create, params: params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      comment
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      request.headers[JWTSessions.csrf_header] = tokens[:csrf]
    end

    it 'destroys the requested comment' do
      request.cookies[JWTSessions.access_cookie] = tokens[:access]
      request.headers[JWTSessions.csrf_header] = tokens[:csrf]
      expect do
        delete :destroy, params: { id: comment.id }
      end.to change(Comment, :count).by(-1)
    end
  end
end
