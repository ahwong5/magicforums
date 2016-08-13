class Topic < ApplicationRecord
  has_many :posts
  belongs_to :user
  paginates_per 4
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 5}, presence: true
end
