class UsersController < ApplicationController
  
  before_action :signed_in_user, only: [:edit, :update]
  
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


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def signed_in_user
      unless signed_in?
        flash[:danger] = "Please log in to access that page"
        redirect_to signin_path
      end
    end
end
