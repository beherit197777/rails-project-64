# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Rails >= 5

  setup do
    sign_in users(:first)
    @post = posts(:first)
    @root_comment = post_comments(:root_comment1)
    @nested_comment = post_comments(:nested_comment1)
  end

  test 'should create comment' do
    post post_comments_path(@post), params: { post_comment: { content: @root_comment.content } }

    created_post_comment =
      PostComment.find_by(
        post_id: @root_comment.post_id,
        ancestry: @root_comment.ancestry,
        content: @root_comment.content
      )

    assert(created_post_comment)
    assert_redirected_to post_url(@post)
  end

  test 'should create nested comment' do
    post post_comments_path(@post), params: { post_comment: { content: @nested_comment.content, parent_id: ActiveRecord::FixtureSet.identify(:root_comment1) } }

    created_post_comment =
      PostComment.find_by(
        post_id: @nested_comment.post_id,
        ancestry: @nested_comment.ancestry,
        content: @nested_comment.content
      )

    assert(created_post_comment)
    assert_redirected_to post_url(@post)
  end
end