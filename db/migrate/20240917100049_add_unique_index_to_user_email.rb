# frozen_string_literal: true

class AddUniqueIndexToUserEmail < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, :email, if_exists: true
    add_index :users, :email, unique: true
  end
end
