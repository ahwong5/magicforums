class AddUserIdToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :user_id, :integer
  end
end

# use the following command in Terminal: rails g migration AddUserIdToTopics user_id:integer to create this file
