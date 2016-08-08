class Comment < ApplicationRecord
  belongs_to :post
  validates :body, length: { minimum: 20}, presence: true
end
