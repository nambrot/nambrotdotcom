class PostsController < ApplicationController
  PostNotFound = Class.new(StandardError)
  rescue_from PostNotFound, with: :redirect_to_root

  def index
    @posts = Post.all
    if params[:tags]
      @posts = @posts.select { |post| post.categories.include? params[:tags] }
    end
  end

  def show
    @post = Post.all.find { |post| post.id.to_s == params[:id].match(/^(\d+)(-|$)/)[1] }
    raise PostNotFound unless @post
  end

  def resume
    render 'pages/resume', layout: false
  end

  private

  def redirect_to_root
    redirect_to posts_path
  end

end
