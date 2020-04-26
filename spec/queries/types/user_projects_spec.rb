require 'rails_helper'

RSpec.describe 'All user projects', type: :request do
  let(:user) { create(:user) }
  let(:search_string) { 'search_string' }
  let(:random_string) { FFaker::Lorem.sentence }
  let(:content) { "#{search_string} #{random_string}" }
  let(:project) { create(:project, user: user, name: content) }
  let(:task) { create(:task, project: project, name: content) }
  let(:comment) { create(:comment, task: task, body: content) }
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

  describe 'multisearch' do
    let(:query) do
      <<-GRAPHQL
          query {
            multisearch(string: "#{search_string}") {
              searchableId
              searchableType
              content
            }
          }
      GRAPHQL
    end

    it 'returns search results for all models' do
      json_response[:data][:multisearch].each do |object|
        expect(object[:content]).to include(search_string)
      end
    end

    it 'returns three objects' do
      expect(json_response[:data][:multisearch].size).to eq(3)
      expect(json_response[:data][:multisearch].map { |object| object[:searchableType] }).to include('Project', 'Task', 'Comment')
    end
  end

  describe 'dynamic search' do
    context 'first name' do
      let(:query) do
        <<-GRAPHQL
            query {
              findUsersByFirstName(name: "#{user.first_name}") {
                email
                firstName
              }
            }
        GRAPHQL
      end

      it 'returns user' do
        expect(json_response[:data][:findUsersByFirstName].first).to include(
          email: user.email,
          firstName: user.first_name
        )
      end
    end

    context 'last name' do
      let(:query) do
        <<-GRAPHQL
            query {
              findUsersByLastName(name: "#{user.last_name}") {
                email
                lastName
              }
            }
        GRAPHQL
      end

      it 'returns user' do
        expect(json_response[:data][:findUsersByLastName].first).to include(
          email: user.email,
          lastName: user.last_name
        )
      end
    end
  end

  describe 'full text search with negation' do
    let(:search_prefix) { user.email[0, 3] }
    let(:second_user) { create(:user, email: "#{search_prefix}some_email@i.ua") }
    let(:query) do
      <<-GRAPHQL
          query {
            searchUserFullText(string: "#{search_prefix} !#{second_user.email}") {
              id
              email
            }
          }
      GRAPHQL
    end

    it 'returns user' do
      expect(json_response[:data][:searchUserFullText].size).to eq(1)
      expect(json_response[:data][:searchUserFullText].first).to include(
        email: user.email,
        id: user.id.to_s
      )
    end
  end

  describe 'searching through associations' do
    let(:query) do
      <<-GRAPHQL
          query {
            findProjectsByTaskName(taskName: "#{task.name}") {
              id
              tasks {
                name
              }
            }
          }
      GRAPHQL
    end

    it 'returns project' do
      expect(json_response[:data][:findProjectsByTaskName]).to include(
        id: project.id.to_s,
        tasks: [{
          name: task.name
        }]
      )
    end
  end

  describe 'full text search by any word with highlight' do
    let(:query) do
      <<-GRAPHQL
          query {
            commentSearch(string: "#{search_string}")
          }
      GRAPHQL
    end

    it 'returns project' do
      expect(json_response[:data][:commentSearch]).to include('<b>search</b>_<b>string</b>')
    end
  end
end
