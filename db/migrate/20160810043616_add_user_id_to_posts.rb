class AddUserIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :user_id, :integer
  end
end

# use the following command in Terminal: rails g migration AddUserIdToPosts user_id:integer to create this file
