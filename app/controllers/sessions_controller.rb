class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: sess_param[:email].downcase)
    remember_value = Settings.remember_me
    if user&.authenticate(sess_param[:password])
      log_in user
      sess_param[:remember_me] == remember_value ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t "signin_page.fail_account"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def sess_param
    params.require(:session)
          .permit :email, :password, :remember_me
  end
end
