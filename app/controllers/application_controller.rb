class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def login_required
    authenticate_user!
  end

  def append_info_to_payload(payload)
    super
    exceptions = %w(controller action format id)
    payload[:host] = request.host
    payload[:remote_ip] = request.remote_ip
    payload[:request_id] = request.uuid
    payload[:params] = ActionDispatch::Http::ParameterFilter.new(['password']).filter(request.params.except(*exceptions))
    payload[:format] = request.format.try(:ref)
  end

  def error_404
    redirect_to root_path
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
