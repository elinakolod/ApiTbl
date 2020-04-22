require 'rails_helper'

RSpec.describe 'Destroy Comment', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let(:comment_id) { comment.id }
  let(:comment) { create(:comment, task: task) }
  let(:headers) { user.create_new_auth_token }
  let(:query) do
    <<-GRAPHQL
      mutation {
        destroyComment( input:
          {
            id: #{comment_id}
          })
          {
            commentId,
            errors
          }
      }
    GRAPHQL
  end
  let(:request) { post(graphql_path, params: { query: query }, headers: headers) }

  before do
    comment
  end

  context 'comment exists' do
    it 'deletes comment' do
      expect { request }.to change(Comment, :count).by(-1)
    end

    it 'returns comment id' do
      request

      expect(json_response[:data][:destroyComment][:commentId]).to eq(comment_id.to_s)
      expect(json_response[:data][:destroyComment][:errors]).to be_empty
    end
  end

  context 'comment does not exist' do
    let(:comment_id) { Comment.count + 1 }

    it 'does not create comment' do
      expect { request }.not_to change(Comment, :count)
    end

    it 'returns errors' do
      request

      expect(json_response[:data][:destroyComment][:errors].first).to include('Doesn\'t exist')
    end
  end
end
