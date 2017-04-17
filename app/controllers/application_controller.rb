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
    NamsPaas.instrument('RAILS_ERROR', serviceContext: { service: 'nambrotdotcom' }, message: "com.example.shop.Template$CartDiv retrieveCart: Error\njava.lang.IndexOutOfBoundsException: Index: 4, Size: 4\n\tat java.util.ArrayList.rangeCheck(ArrayList.java:635)\n\tat java.util.ArrayList.get(ArrayList.java:411)\n\tat com.example.shop.Cart.retrieve(Cart.java:76)\n\tat com.example.shop.Cart.generate(Cart.java:55)\n\tat com.example.shop.Template$CartDiv.retrieveCart(Template.java:113)\n\tat com.example.shop.Template.generate(Template.java:22)\n\tat com.example.shop.CartServlet.doGet(CartServlet.java:115)\n\tat javax.servlet.http.HttpServlet.service(HttpServlet.java:717)\n",, context: { path: request.path, request_id: request.uuid, reportLocation: { filePath: "/something.js", lineNumber: 3, functionName: "foo"} })
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
