# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, dependent: :delete_all
  has_many :friendships, dependent: :delete_all
  has_many :likes, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :friends, through: :friendships, dependent: :delete_all

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def filter_current_user(list)
    list.reject { |user| user.id == id }
  end

  def friends_with?(id)
    friends.where(id: id).exists?
  end

  def liked_post?(post)
    likes.where(
      {
        likeable_id: post.id, likeable_type: post.class.name,
      }
    ).count.positive?
  end

  def liked_comment?(comment)
    likes.where(
      {
        likeable_id: comment.id, likeable_type: comment.class.name,
      }
    ).count.positive?
  end

  def self.search(friend)
    friend = "%#{friend.strip}%"
    users = where('email LIKE ? OR first_name LIKE ? OR last_name LIKE ?', friend, friend, friend)
    return nil if users.empty?

    users
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name

    'Unknown User '
  end
end
