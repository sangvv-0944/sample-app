class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: sessions_params[:email].downcase)
    if user&.authenticate(sessions_params[:password])
      log_in user
      sessions_params[:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = t "signin_page.fail_account"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def sessions_params
    params.require(:session).permit :email, :password, :remember_me
  end
end
