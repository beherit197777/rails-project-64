# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Rails >= 5

  setup do
    @user = users(:first)
    @post1 = posts(:first)
    @post2 = posts(:second)
    @like1 = post_likes(:first)
    @like2 = post_likes(:second)
    sign_in @user
  end

  test 'create' do
    post post_likes_path(@post2)

    created_post_like = PostLike.find_by(
      post_id: @post2.id,
      user_id: @user.id
    )

    assert(created_post_like)
    assert_redirected_to post_url(@post2)
  end

  test 'destroy' do
    delete post_like_path(@post1, @like1)

    deleted_post_like = PostLike.find_by(
      post_id: @post2.id,
      user_id: @user.id
    )

    assert_nil(deleted_post_like)
    assert_redirected_to post_url(@post1)
  end

  test 'destroy by other user' do
    assert_no_difference('PostLike.count') do
      delete post_like_path(@post2, @like2)
    end

    assert_redirected_to post_url(@post2)
  end
end