class Topic < ApplicationRecord
  has_many :posts
  belongs_to :user
  paginates_per 4
  validates :title, length: { minimum: 2 }, presence: true
  validates :description, length: { minimum: 2}, presence: true

  extend FriendlyId
  friendly_id :title, use: :slugged
end
