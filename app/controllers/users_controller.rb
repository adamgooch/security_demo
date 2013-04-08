class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new( params[:user] )
    @user.email = params[:user][:email].downcase
    @user.salt = make_salt
    @user.password_digest = encrypt_password( @user.password, @user.salt )
    if @user.save
      flash[:success] = "Welcome to Ramekin Technologies!"
      login( @user )
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find_by_id params[:id]
    if( signed_in? && current_user?( @user ) )
      flash.now[:success] = "Signed In!"
    else
      flash.now[:error] = "You are not allowed here!"
    end
  end
end
