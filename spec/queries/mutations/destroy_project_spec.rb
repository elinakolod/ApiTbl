require 'rails_helper'

RSpec.describe 'Destroy Project', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:project_id) { project.id }
  let(:query) do
    <<-GRAPHQL
      mutation {
        destroyProject( input:
          {
            id: #{project_id}
          })
          {
            projectId,
            errors
          }
      }
    GRAPHQL
  end
  let(:request) { post(graphql_path, params: { query: query }) }

  before do
    project
  end

  context 'project exists' do
    it 'deletes project' do
      expect { request }.to change(Project, :count).by(-1)
    end

    it 'returns project id' do
      request

      expect(json_response[:data][:destroyProject][:projectId]).to eq(project_id.to_s)
      expect(json_response[:data][:destroyProject][:errors]).to be_empty
    end
  end

  context 'project does not exist' do
    let(:project_id) { Project.count + 1 }

    it 'does not create project' do
      expect { request }.not_to change(Project, :count)
    end

    it 'returns errors' do
      request

      expect(json_response[:data][:destroyProject][:errors].first).to include('Doesn\'t exist')
    end
  end
end
