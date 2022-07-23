# frozen_string_literal: true

class RemoveTitleFromPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :title
  end
end
