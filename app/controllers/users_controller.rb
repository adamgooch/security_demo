class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.password_digest = encrypt_password(@user.password)
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

  private

  def encrypt_password(plain_text)
    plain_text
  end
end
