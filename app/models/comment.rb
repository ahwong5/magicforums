class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :votes
  paginates_per 4
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 5}, presence: true

  def total_votes
    votes.pluck(:value).sum
  end
end
