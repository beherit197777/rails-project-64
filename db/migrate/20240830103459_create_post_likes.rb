class CreatePostLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :post_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps

      t.index %i[post_id user_id], unique: true, name: 'uniq_post_like_per_user'
    end
  end
end