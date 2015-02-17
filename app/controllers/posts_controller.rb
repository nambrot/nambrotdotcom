class PostsController < ApplicationController
  
  before_filter :authenticate_user!, except: [:index, :show]

  caches_action :index, :show

  def index
    @posts = Post.order('created_at DESC')
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.blog_posts.new(params.key(:post) || {})
  end

  def edit
    @post = current_user.blog_posts.find(params[:id])
  end

  def create
    @post = current_user.blog_posts.new(valid_params)
    if @post.save
      Rails.cache.clear
      redirect_to @post
    else
      render action: "new"
    end
  end

  def update
    @post = current_user.blog_posts.find(params[:id])
    if @post.update_attributes(valid_params)
      Rails.cache.clear
      redirect_to @post
    else
      render action: "edit"
    end
  end

  def destroy
    @post = current_user.blog_posts.find(params[:id])
    @post.destroy
    Rails.cache.clear
    redirect_to posts_url
  end

  protected

  def valid_params
    params.require(:post).permit(:title, :summary, :body, :blogger_type, :blogger_id)
  end

end
