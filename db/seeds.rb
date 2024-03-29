# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?

  ActiveRecord::Base.transaction do
    user1 = User.create!(
      email: 'user@gmail.com',
      first_name: 'John',
      last_name: 'Doe',
      password: 'password',
      password_confirmation: 'password'
    )

    user2 = User.create!(
      email: 'user2@gmail.com',
      first_name: 'Jane',
      last_name: 'Doe',
      password: 'password',
      password_confirmation: 'password'
    )

    Friendship.create!(user: user1, friend: user2)
  end
end
