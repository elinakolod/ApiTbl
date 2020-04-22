require 'rails_helper'

RSpec.describe 'Update Task', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project, done: false) }
  let(:task_id) { task.id }
  let(:new_name) { 'new_name' }
  let(:headers) { user.create_new_auth_token }
  let(:new_done) { true }
  let(:query) do
    <<-GRAPHQL
      mutation {
        updateTask( input:
          {
            id: #{task_id},
            name: "#{new_name}",
            done: #{new_done}
          })
          {
            errors
          }
      }
    GRAPHQL
  end
  let(:request) { post(graphql_path, params: { query: query }, headers: headers) }

  before do
    task
    request
  end

  context 'valid params' do
    it 'updates task' do
      task.reload
      expect(task.name).to eq(new_name)
      expect(task.done).to eq(new_done)
      expect(json_response[:data][:updateTask][:errors]).to be_empty
    end
  end

  context 'invalid params' do
    let(:new_name) { '' }

    it 'does not update task' do
      project.reload
      expect(task.name).not_to eq(new_name)
      expect(task.done).not_to eq(new_done)
      expect(json_response[:data][:updateTask][:errors].first).to include('must be filled')
    end
  end
end
