require 'rails_helper'

RSpec.describe 'All user projects', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment) { create(:comment, task: task) }
  let(:headers) { user.create_new_auth_token }
  let(:query) do
    <<-GRAPHQL
        query {
          user {
            email
            projects {
              name
              createdAt
              tasks {
                name
                done
                createdAt
                comments {
                  body
                  createdAt
                }
              }
            }
          }
        }
    GRAPHQL
  end

  before do
    comment
    post graphql_path, params: { query: query }, headers: headers
  end

  it 'returns all user projects with tasks and comments' do
    expect(json_response[:data][:user]).to include(
      email: user.email,
      projects: [{
        createdAt: project.created_at.to_formatted_s,
        name: project.name,
        tasks: [{
          comments: [{
            body: comment.body,
            createdAt: comment.created_at.to_formatted_s
          }],
          createdAt: task.created_at.to_formatted_s,
          done: task.done,
          name: task.name
        }]
      }]
    )
  end
end
