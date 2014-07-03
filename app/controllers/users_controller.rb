class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index]
  before_action :correct_user, only: [:edit, :update]

  def index
    #@users = User.all
    # page param comes from magic will_paginate method
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
    #@user = User.find(params[:id])
    # > covered by before action correct_user now
  end

  def update
    #@user = User.find(params[:id])
    # > covered by before action correct_user now
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
    unless signed_in?
      store_location
      # using signed_in? method from helpers/sessions_helper
      redirect_to signin_path, notice: 'Please sign in.'
    end
  end

  def correct_user
    @user = User.find(params[:id])

     # using current_user? method from helpers/sessions_helper
     redirect_to root_path unless current_user?(@user)
  end
end
