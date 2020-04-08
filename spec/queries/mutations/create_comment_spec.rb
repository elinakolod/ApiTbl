require 'rails_helper'

RSpec.describe 'Create Comment', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:task_id) { task.id }
  let(:comment) { build(:comment) }
  let(:body) { comment.body }
  let(:query) do
    <<-GRAPHQL
      mutation {
        createComment( input:
          {
            body: "#{body}",
            taskId: #{task_id}
          })
          {
            comment {
              body
              task { id }
          } errors
        }
      }
    GRAPHQL
  end
  let(:request) { post(graphql_path, params: { query: query }) }

  context 'valid body' do
    it 'creates comment' do
      expect { request }.to change(Comment, :count).by(1)
    end

    it 'returns comment info' do
      request

      expect(json_response[:data][:createComment][:comment]).to include(
        body: body,
        task: {
          id: task_id.to_s
        }
      )
      expect(json_response[:data][:createComment][:errors]).to be_empty
    end
  end

  context 'invalid body' do
    let(:body) { '' }

    it 'does not create comment' do
      expect { request }.not_to change(Comment, :count)
    end

    it 'returns errors' do
      request

      expect(json_response[:data][:createComment][:errors].first).to include('must be filled')
    end
  end
end
