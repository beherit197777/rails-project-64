# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :category
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id', inverse_of: 'posts'
  has_many :comments, dependent: :destroy, class_name: 'PostComment', inverse_of: 'post'
  has_many :likes, dependent: :destroy, class_name: 'PostLike', inverse_of: 'post'

  validates :title, presence: true, length: { minimum: 5, maximum: 255 }
  validates :body, presence: true, length: { minimum: 200, maximum: 4000 }

  def like_by_user(current_user)
    return nil if current_user.nil?

    likes.find_by({ user_id: current_user.id })
  end
end
