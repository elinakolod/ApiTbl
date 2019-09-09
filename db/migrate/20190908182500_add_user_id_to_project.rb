class AddUserIdToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :user_id, :integer
    add_foreign_key :projects, :users
  end
end
