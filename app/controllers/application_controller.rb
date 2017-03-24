class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def login_required
    authenticate_user!
  end

  protected
  def rescue_not_found
    if params[:controller] == "blogit/posts"
      # couldn't find some blog entry
      redirect_to blog_root_path
    else
      render :template => 'application/not_found', :status => :not_found
    end
  end
end
