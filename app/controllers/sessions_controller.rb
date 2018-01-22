class SessionsController < ApplicationController
  def new; end

  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase
    if user && user.authenticate(session[:password])
      log_in_or_active_warning user
    else
      warning_invalid_and_redirect
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def log_in_or_active_warning user
    if user.activated?
      log_in_and_redicrect user
    else
      active_warning_and_redirect
    end
  end

  def log_in_and_redicrect user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or root_path
  end

  def active_warning_and_redirect url_default = root_url
    message  = t "flash.account_activation.active_message"
    message += t "flash.account_activation.check_email"
    flash[:warning] = message
    redirect_to url_default
  end

  def warning_invalid_and_redirect
    flash.now[:danger] = t "flash.login.invalid_email_password"
    render :new
  end
end
