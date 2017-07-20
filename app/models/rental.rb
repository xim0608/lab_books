class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :book

  scope :unread, -> { where(unread: true) }
end
