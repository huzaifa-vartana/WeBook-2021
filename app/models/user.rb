class User < ApplicationRecord
  has_many :posts
  has_many :friendships
  has_many :likes
  has_many :comments
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def filter_current_user(list)
    list.reject { |user| user.id == self.id }
  end

  def friends_with?(id)
    friends.where(id: id).exists?
  end

  def liked_post?(post)
    likes.where(
      {
        :likeable_id => post.id, :likeable_type => post.class.name,
      }
    ).count > 0
  end

  def liked_comment?(comment)
    likes.where(
      {
        :likeable_id => comment.id, :likeable_type => comment.class.name,
      }
    ).count > 0
  end

  def self.search(friend)
    friend = "%#{friend.strip}%"
    users = where("email LIKE ? OR first_name LIKE ? OR last_name LIKE ?", friend, friend, friend)
    return nil if users.empty?
    users
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Unknown User "
  end
end
