# frozen_string_literal: true

require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @post = posts(:one)
    @category = categories(:one)
    @attrs = {
      title: Faker::Movies::HarryPotter.character,
      body: Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false),
      category_id: @category.id
    }
    sign_in @user
  end

  test 'should get index' do
    get posts_path

    assert_response :success
  end

  test 'should get show' do
    get post_path(@post)

    assert_response :success
  end

  test 'should get new' do
    get new_post_path

    assert_response :success
  end

  test 'should get create' do
    post posts_url, params: { post: @attrs }

    post = Post.find_by @attrs

    assert { post }
    assert_redirected_to post_url(post)
  end
end
