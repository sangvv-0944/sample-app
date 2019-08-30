class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.per_page_user
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page],
      per_page: Settings.per_page_post)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "signup_page.message_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t "profile_pages.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "profile_pages.delete_success"
    else
      flash[:danger] = t "profile_pages.user_delete_fails"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    redirect_to root_url unless current_user?(@user)
  end

  # Confirm admin user
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "profile_pages.user_notfound"
    redirect_to root_path
  end
end
