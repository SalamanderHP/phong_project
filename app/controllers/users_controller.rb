class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :load_user, except: %i(index create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.paginate.pages
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_email_activate
      flash[:info] = t ".check_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t ".new.error"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".edit.success"
      redirect_to @user
    else
      flash.now[:danger] = t ".edit.error"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".destroy.destroyed"
    else
      flash[:danger] = t ".destroy.destroy_fail"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".edit.not_logged_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
