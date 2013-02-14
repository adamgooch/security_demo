module AuthenticationHelper

  def authenticate( email, submitted_password )
    user = User.find_by_email( email.downcase )
    ( user && user.password_digest == encrypt_password( submitted_password ) ) ? user : nil
  end

  def authenticate_with_cookie( id )
    user = User.find_by_id( id )
    user ? user : nil
    #user && user.email == email ? user : nil
  end

  def encrypt_password( plain_text )
    plain_text
  end

  def login( user )
    cookies[:remember_token] = user.id
    #cookies.signed[:remember_token] = [user.id, user.email]
    #current_user = user
  end

  def current_user=( user )
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user?( user )
    @current_user == user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete :remember_token
    current_user = nil
  end

  private

    def user_from_remember_token
      authenticate_with_cookie( remember_token )
      #authenticate_with_cookie( *remember_token )
      #authenticate_with_cookie( session[:user_id] )
    end

    def remember_token
      cookies[:remember_token] || nil
      #cookies.signed[:remember_token] || [nil, nil]
    end
end
