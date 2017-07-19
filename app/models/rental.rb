class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :book
  soft_deletable
end
