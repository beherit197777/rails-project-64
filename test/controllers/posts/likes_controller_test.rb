# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @post = posts(:one)
    @user = users(:two)
    @liked_post = posts(:two)
    @like_of_liked_post = post_likes(:two)
    @like_from_another_user = post_likes(:one)

    sign_in(@user)
  end

  test 'should create like' do
    post post_likes_url(@post)

    assert @post.likes.find_by(user: @user)

    assert_redirected_to post_url(@post)
  end

  test 'should not create like when post has user like' do
    assert_no_difference 'PostLike.count' do
      post post_likes_url(@liked_post)
    end

    assert_redirected_to post_url(@liked_post)
  end

  test 'should destroy like' do
    delete post_like_url(@liked_post, @like_of_liked_post)

    assert_not @liked_post.likes.find_by(user: @user)

    assert_redirected_to post_url(@liked_post)
  end

  test 'should not create like for unauthorized user' do
    sign_out(@user)

    assert_no_difference 'PostLike.count' do
      post post_likes_url(@post)
    end

    assert_redirected_to new_user_session_path
  end

  test 'should not destroy like for unauthorized user' do
    sign_out(@user)

    assert_no_difference 'PostLike.count' do
      delete post_like_url(@liked_post, @like_of_liked_post)
    end

    assert_redirected_to new_user_session_path
  end

  test 'should not destroy like from another user' do
    assert_no_difference 'PostLike.count' do
      delete post_like_url(@like_from_another_user.post, @like_from_another_user)
    end

    assert_redirected_to post_url(@like_from_another_user.post)
  end
end
