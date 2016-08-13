class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  paginates_per 4
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 5}, presence: true
end
