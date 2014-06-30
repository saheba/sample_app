class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # handle successful update
      flash[:success] ="Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      flash[:success] = "Welcome :)"
      sign_in @user
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  private 
  def user_params
    #how is params accessible inside this method >> TODO find answer in Rails API
  	return params.require(:user).permit( :name, :email, :password, :password_confirmation)
  end

  def signed_in_user
    redirect_to signin_path, notice: 'Please sign in.' unless signed_in?
  end
end
