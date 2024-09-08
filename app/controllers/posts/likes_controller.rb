# frozen_string_literal: true

class Posts::LikesController < Posts::ApplicationController
  before_action :authenticate_user!

  def create
    resource_post.likes.create(user: current_user) unless already_liked?
    redirect_to post_path(resource_post)
  end

  def destroy
    @like = PostLike.find_by(id: params[:id])
    return if @like.blank?

    @like.destroy if @like.user == current_user
    redirect_to post_path(resource_post)
  end

  private

  def already_liked?
    resource_post.likes.exists?(user: current_user)
  end
end
