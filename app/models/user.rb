class User < ApplicationRecord
  has_secure_password

  has_many :topics
  has_many :posts
  has_many :comments
  has_many :votes

  extend FriendlyId
  friendly_id :username, use: :slugged

  mount_uploader :image, ImageUploader

  validates :email, presence: true,
              length: { minimum: 5 },
              :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ , message: "check your email format." }

  validates :username, presence: true,
                    length: { minimum: 2},
                    uniqueness: { message: "%{value} has taken already, please try another one." },
                    format: { with: /\A[a-zA-Z0-9]+\Z/ , message: "No space or special character is allowed." }

  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40},
                       :on => :create
  validates :password_confirmation, :presence => true,
                       :length => {:within => 6..40},
                       :allow_blank => true,
                       :on => :create

  enum role: [:user, :moderator, :admin]
end
