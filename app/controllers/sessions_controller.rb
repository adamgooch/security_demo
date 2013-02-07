class SessionsController < ApplicationController
  def new
  end

  def create
    @email = params[:session][:email]
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      render :new
    else
      redirect_to user
    end
  end

  def destroy
  end
end
