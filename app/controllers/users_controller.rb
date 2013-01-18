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
    if params[:user]["password"] != params[:user]["password_confirmation"]
      flash.now[:error] = 'Failed: Password does not match confirmation'
      render :new
    elsif User.find_by_email @user.email
      flash.now[:error] = 'Failed: Email taken'
      render :new
    elsif @user.save
      redirect_to @user
    else
      flash.now[:error] = 'Failed: Email bad format'
      render :new
    end
  end

  def show
    @user = User.find_by_id params[:id]
  end
end
