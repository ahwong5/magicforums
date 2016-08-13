class PasswordReset < ApplicationRecord
  validates :email, presence: true,
end
