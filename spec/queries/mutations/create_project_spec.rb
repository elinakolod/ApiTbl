require 'rails_helper'

RSpec.describe 'Create Project', type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:project) { build(:project) }
  let(:name) { project.name }
  let(:query) do
    <<-GRAPHQL
      mutation {
        createProject( input:
          {
            name: "#{name}",
            userId: #{user_id}
          })
          {
            project {
              name
              user { id }
          } errors
        }
      }
    GRAPHQL
  end
  let(:request) { post(graphql_path, params: { query: query }) }

  context 'valid name' do
    it 'creates project' do
      expect { request }.to change(Project, :count).by(1)
    end

    it 'returns project info' do
      request

      expect(json_response[:data][:createProject][:project]).to include(
        name: name,
        user: {
          id: user_id.to_s
        }
      )
      expect(json_response[:data][:createProject][:errors]).to be_empty
    end
  end

  context 'invalid name' do
    let(:name) { '' }

    it 'does not create project' do
      expect { request }.not_to change(Project, :count)
    end

    it 'returns errors' do
      request

      expect(json_response[:data][:createProject][:errors].first).to include('must be filled')
    end
  end
end
