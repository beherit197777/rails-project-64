# frozen_string_literal: true

class PostComment < ApplicationRecord
  belongs_to :post, inverse_of: 'comments'
  belongs_to :user, inverse_of: 'comments'
  has_ancestry
  validates :content, presence: true, length: { minimum: 5, maximum: 400 }
end
