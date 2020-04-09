require 'rails_helper'

RSpec.describe 'Update Project', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:project_id) { project.id }
  let(:new_name) { 'new_name' }
  let(:headers) { user.create_new_auth_token }
  let(:query) do
    <<-GRAPHQL
      mutation {
        updateProject( input:
          {
            id: #{project_id},
            name: "#{new_name}"
          })
          {
            errors
          }
      }
    GRAPHQL
  end
  let(:request) { post(graphql_path, params: { query: query }, headers: headers) }

  before do
    project
    request
  end

  context 'valid name' do
    it 'updates project' do
      project.reload
      expect(project.name).to eq(new_name)
      expect(json_response[:data][:updateProject][:errors]).to be_empty
    end
  end

  context 'invalid name' do
    let(:new_name) { '' }

    it 'does not update project' do
      project.reload
      expect(project.name).not_to eq(new_name)
      expect(json_response[:data][:updateProject][:errors].first).to include('must be filled')
    end
  end
end
