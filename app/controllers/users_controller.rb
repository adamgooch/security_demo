class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.email = params[:user]["email"]
    @user.password_digest = params[:user]["password"]
    if params[:user]["password"] == params[:user]["password_confirmation"] && @user.save
      redirect_to @user
    else
      flash.now[:error] = 'Password and confirmation must match'
      render :new
    end
  end

  def show
    @user = User.find_by_id params[:id]
  end
end
