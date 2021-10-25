class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable
  validates :body, presence: true, length: { minimum: 2, maximum: 50 }
end
