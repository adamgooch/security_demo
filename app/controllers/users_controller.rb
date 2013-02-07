class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.email = params[:user][:email].downcase
    @user.password_digest = User.encrypt_password(params[:user][:password])
    if @user.save
      flash[:success] = "Welcome to the Community!"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find_by_id params[:id]
  end
end
