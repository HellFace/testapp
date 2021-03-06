class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def index
    @users = User.paginate page: params[:page], per_page: 20
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Test App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if (@user.update_attributes(user_params))
      flash[:success] = "Profile successfully updated"
      redirect_to @user
    else
      render 'edit'  
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User is deleted"
    redirect_to users_path
  end


  private
    # Default User params for mass assignment
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Restriction for signed in users only
    def signed_in_user
      unless signed_in?
        store_location
        flash[:danger] = "Please log in to access that page"
        redirect_to signin_path
      end
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    # Only authorized users 
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
end
