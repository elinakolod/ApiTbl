require 'rails_helper'

RSpec.describe 'Create Task', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:project_id) { project.id }
  let(:task) { build(:task) }
  let(:name) { task.name }
  let(:query) do
    <<-GRAPHQL
      mutation {
        createTask( input:
          {
            name: "#{name}",
            projectId: #{project_id}
          })
          {
            task {
              name
              done
              project { id }
          } errors
        }
      }
    GRAPHQL
  end
  let(:request) { post(graphql_path, params: { query: query }) }

  context 'valid name' do
    it 'creates task' do
      expect { request }.to change(Task, :count).by(1)
    end

    it 'returns task info' do
      request

      expect(json_response[:data][:createTask][:task]).to include(
        name: name,
        done: false,
        project: {
          id: project_id.to_s
        }
      )
      expect(json_response[:data][:createTask][:errors]).to be_empty
    end
  end

  context 'invalid name' do
    let(:name) { '' }

    it 'does not create task' do
      expect { request }.not_to change(Task, :count)
    end

    it 'returns errors' do
      request

      expect(json_response[:data][:createTask][:errors].first).to include('must be filled')
    end
  end
end
