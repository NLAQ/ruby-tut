class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if user
      send_reset_email_and_redirect
    else
      flash.now[:danger] = t "flash.forget_password.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      user.errors.add :password, t("flash.reset_password.empty")
      render :edit
    elsif user.update_attributes user_params
      log_in_and_redirect user
    else
      render :edit
    end
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if user && user.activated? && user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "flash.forget_password.expired"
    redirect_to new_password_reset_url
  end

  def send_reset_email_and_redirect default_url = root_url
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t "flash.forget_password.send_email"
    redirect_to default_url
  end

  def log_in_and_redirect user
    log_in user
    flash[:success] = t "flash.forget_password.reset"
    redirect_to user
  end
end
