class AdminController < ApplicationController
  before_filter :login_reqiured

  def clear_cache
    render :json => Rails.cache.clear
  end
end
