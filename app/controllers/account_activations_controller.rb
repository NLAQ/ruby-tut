class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      active_and_redirect user
    else
      warning_and_back
    end
  end

  private

  def active_and_redirect user
    user.activate
    log_in user
    flash[:success] = t "flash.account_activation.activated"
    redirect_to user
  end

  def warning_and_back url_default = root_url
    flash[:danger] = t "flash.account_activation.invalid_link"
    redirect_to url_default
  end
end
