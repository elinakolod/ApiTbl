require 'rails_helper'

RSpec.describe 'All user projects', type: :request do
  let(:user) { create(:user) }
  let(:search_string) { 'search_string' }
  let(:project) { create(:project, user: user, name: "#{search_string} #{FFaker::Lorem.sentence}") }
  let(:task) { create(:task, project: project, name: "#{search_string} #{FFaker::Lorem.sentence}") }
  let(:comment) { create(:comment, task: task, body: "#{search_string} #{FFaker::Lorem.sentence}") }
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
  end

  it 'returns all user projects with tasks and comments' do
    post graphql_path, params: { query: query }, headers: headers
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

  describe 'elasticsearch' do
    before(:each) do
      Task.__elasticsearch__.refresh_index!
      Comment.__elasticsearch__.refresh_index!
      Project.__elasticsearch__.refresh_index!
    end

    after(:each) do
      Task.__elasticsearch__.delete_index!
      Comment.__elasticsearch__.delete_index!
      Project.__elasticsearch__.delete_index!
    end

    let(:query) do
      <<-GRAPHQL
        query {
          search(string: "#{search_string}"){
            ... on Project {
              id
              name
            }
            ... on Task {
              id
              name
            }
            ... on Comment {
              id
              body
            }
          }
        }
      GRAPHQL
    end

    it 'returns search results for all models' do
      post graphql_path, params: { query: query }, headers: headers
      expect(json_response[:data][:search].size).to eq(3)
      json_response[:data][:search].map { |object| object.values.last }.each do |search_result|
        expect(search_result).to include(search_string)
      end
      expect(json_response[:data][:search].map { |object| object[:id] })
        .to include(project.id.to_s, task.id.to_s, comment.id.to_s)
    end
  end
end
