class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :index]
  before_action :anonymous_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :not_self, only: :destroy

  def index
    #@users = User.all
    # page param comes from magic will_paginate method
    @users = User.paginate(page: params[:page], order: :id)
  end

  def new
  	   @user = User.new
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
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
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def not_self
      redirect_to(root_url) if (current_user.id.to_s == params[:id])
  end

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

  def anonymous_user    
    if signed_in?
      #store_location
      # using signed_in? method from helpers/sessions_helper
      redirect_to root_path, notice: 'You are already signed in.'
    end
  end

  def correct_user
    @user = User.find(params[:id])

     # using current_user? method from helpers/sessions_helper
     redirect_to root_path unless current_user?(@user)
  end
end
