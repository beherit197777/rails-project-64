# frozen_string_literal: true

class Posts::CommentsController < Posts::ApplicationController
  before_action :authenticate_user!

  def create
    @comment = resource_post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash[:notice] = I18n.t('flash.notice.comment_published')
    else
      flash[:error] = I18n.t('flash.error.comment_not_published')
    end
    redirect_to post_path(resource_post)
  end

  private

  def comment_params
    params.require(:post_comment).permit(:content, :parent_id)
  end
end
