# frozen_string_literal: true

module Posts
  class CommentsController < Posts::ApplicationController
    before_action :authenticate_user!
    def create
      @parent_comment = PostComment.find_by(id: comment_params[:parent_id])

      # Проверяем, что родительский комментарий принадлежит тому же посту
      if @parent_comment && @parent_comment.post_id != resource_post.id
        flash[:error] = I18n.t('flash.error.invalid_parent_comment')
        return redirect_to post_path(resource_post)
      end

      @comment = resource_post.comments.build(comment_params)
      @comment.user = current_user
      @comment.parent = @parent_comment if @parent_comment

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
end
