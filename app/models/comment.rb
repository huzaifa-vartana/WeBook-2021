# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :string
#  user_id          :integer          not null
#  commentable_type :string
#  commentable_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :delete_all
  has_many :likes, as: :likeable, dependent: :delete_all
  validates :body, presence: true, length: { minimum: 2, maximum: 50 }
end
