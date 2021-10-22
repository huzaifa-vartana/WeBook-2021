class User < ApplicationRecord
  has_many :posts
  has_many :friendships
  has_many :friends, through: :friendships do
    def just_date
      select(:created_at)
    end
  end

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
