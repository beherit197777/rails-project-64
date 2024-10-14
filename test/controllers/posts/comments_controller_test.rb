# frozen_string_literal: true

require 'test_helper'

class Posts::CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @post = posts(:one)
    @user = users(:two)
    @comment_with_comments = post_comments(:with_comments)
    @comment_belongs_to_another_post = post_comments(:two)

    @attrs = {
      content: Faker::Lorem.paragraph_by_chars(number: 10)
    }
  end

  test 'should not create comment for unauthorized user' do
    assert_no_difference 'PostComment.count' do
      post post_comments_url(@post), params: { post_comment: @attrs }
    end

    assert_redirected_to new_user_session_path
  end

  test 'should create comment for authorized user' do
    sign_in(@user)
    post post_comments_url(@post), params: { post_comment: @attrs }

    post_comment = @post.comments.find_by(@attrs)

    assert post_comment
    assert_equal post_comment.user, @user
    assert_redirected_to post_url(@post)
  end

  test 'should create comment for comment correctly' do
    sign_in(@user)
    post post_comments_url(@post), params: { post_comment: { **@attrs, parent_id: @comment_with_comments.id } }

    post_comment = @post.comments.find_by(@attrs)

    Rails.logger.debug "Созданный комментарий: #{post_comment.inspect}"

    @comment_with_comments.reload

    assert_equal 2, @comment_with_comments.children.count
    assert_includes @comment_with_comments.children, post_comment
  end

  test 'should not create comment when post and parent comment post are not same' do
    sign_in(@user)
    assert_no_difference 'PostComment.count' do
      post post_comments_url(@post),
           params: { post_comment: { **@attrs, parent_id: @comment_belongs_to_another_post.id } }
    end

    assert_redirected_to post_url(@post)
  end
end