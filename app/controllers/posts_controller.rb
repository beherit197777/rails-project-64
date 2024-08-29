class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post = Post.find params[:id]
    @new_comment = PostComment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end
end
