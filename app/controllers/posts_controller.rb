class PostsController < ApplicationController
  def index
    @posts = Post.all
    if params[:tags]
      @posts = @posts.select { |post| post.categories.include? params[:tags] }
    end
  end

  def show
    NamsPaas.instrument('cool event', {foo: :bar})
    @post = Post.all.find { |post| post.id.to_s == params[:id].match(/^(\d+)(-|$)/)[1] }
  end

end
