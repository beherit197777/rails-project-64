class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :set_post, only: :create

  def create
    @root_comment = @post.comments.build(comment_params)
    @root_comment.user = current_user

    respond_to do |format|
      if @root_comment.save
        format.html { redirect_to post_url(@post), notice: I18n.t('comments.create.success') }
      else
        format.html { redirect_to post_url(@post), alert: @root_comment.errors.full_messages.join(".\n") }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:post_comment).permit(:content, :parent_id)
  end
end
