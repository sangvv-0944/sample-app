class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user_followed, only: :create
  before_action :find_user_followed, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_user_followed
    @user = User.find_by(id: params[:followed_id])
    return if @user
    flash[:danger] = t "profile_pages.user_notfound"
    redirect_to root_url
  end

  def find_user_followed
    @relationship = Relationship.find_by(id: params[:id])
    redirect_to root_url unless @relationship
  end
end
