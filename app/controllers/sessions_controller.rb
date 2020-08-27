class SessionsController < ApplicationController
  include SessionsHelper

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      remember_check params[:session][:remember_me], user
      redirect_to user
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    flash[:primary] = t ".logout"
    redirect_to root_url
  end

  private

  def remember_check remember_me, user
    remember_me == Settings.checkbox.checked ? remember(user) : forget(user)
  end
end
