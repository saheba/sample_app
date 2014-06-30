class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
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
end
