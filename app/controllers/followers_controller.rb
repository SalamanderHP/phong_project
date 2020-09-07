class FollowersController < ApplicationController
  before_action :find_user

  def index
    @title = t ".title"
    @users = @user.followers.page(params[:page]).per Settings.paginate.pages
    render "users/show_follow"
  end
end
