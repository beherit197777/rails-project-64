class Post < ApplicationRecord
  belongs_to :category
  validates :title, presence: true, length: { minimum: 5, maximum: 250 }
  validates :body, presence: true, length: { minimum: 200, maximum: 4000 }
end
