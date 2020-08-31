class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      activate_check user
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

  def activate_check user
    if user.activated?
      log_in user
      remember_check params[:session][:remember_me], user
      redirect_back_or user
    else
      flash[:warning] = t ".message"
      redirect_to root_url
    end
  end

  def remember_check remember_me, user
    remember_me == Settings.checkbox.checked ? remember(user) : forget(user)
  end
end
