class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "actived_page.success"
      redirect_to user
    else
      flash[:danger] = t "actived_page.invalid_message"
      redirect_to root_url
    end
  end
end
