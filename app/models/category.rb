# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 1, maximum: 50 }
end
