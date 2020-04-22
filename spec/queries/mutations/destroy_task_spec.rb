require 'rails_helper'

RSpec.describe 'Destroy Task', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:task_id) { task.id }
  let(:headers) { user.create_new_auth_token }
  let(:query) do
    <<-GRAPHQL
      mutation {
        destroyTask( input:
          {
            id: #{task_id}
          })
          {
            taskId,
            errors
          }
      }
    GRAPHQL
  end
  let(:request) { post(graphql_path, params: { query: query }, headers: headers) }

  before do
    task
  end

  context 'task exists' do
    it 'deletes task' do
      expect { request }.to change(Task, :count).by(-1)
    end

    it 'returns task id' do
      request

      expect(json_response[:data][:destroyTask][:taskId]).to eq(task_id.to_s)
      expect(json_response[:data][:destroyTask][:errors]).to be_empty
    end
  end

  context 'task does not exist' do
    let(:task_id) { Task.count + 1 }

    it 'does not create task' do
      expect { request }.not_to change(Task, :count)
    end

    it 'returns errors' do
      request

      expect(json_response[:data][:destroyTask][:errors].first).to include('Doesn\'t exist')
    end
  end
end
