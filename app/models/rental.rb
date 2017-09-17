class Rental < ApplicationRecord
  soft_deletable :column => :return_at
  belongs_to :user
  belongs_to :book

  scope :unread, -> { where(unread: true) }
  scope :history, -> { self.only_soft_destroyed }
  scope :now, -> { self.without_soft_destroyed }
end
