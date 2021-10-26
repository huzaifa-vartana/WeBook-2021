class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :delete_all
  has_many :likes, as: :likeable, dependent: :delete_all
  validates :body, presence: true, length: { minimum: 2, maximum: 50 }
end
