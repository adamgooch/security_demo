module AuthenticationHelper

  def authenticate( email, submitted_password )
    user = User.find_by_email( email.downcase )
    ( user && user.password_digest == encrypt_password( submitted_password ) ) ? user : nil
  end

  def authenticate_with_cookie( id, email = nil )
    user = User.find_by_id( id )
    if Config::SECURE
      user && user.email == email ? user : nil
    else
      user ? user : nil
    end
  end

  def encrypt_password( plain_text )
    plain_text
  end

  def login( user )
    cookies[:remember_token] = user.id unless Config::SECURE || Config::SSL
    cookies.signed[:remember_token] = { secure: true, value: [ user.id, user.email ] } if Config::SSL
    cookies.signed[:remember_token] = { value: [ user.id, user.email ] } if Config::SECURE
    #cookies.signed[:remember_token] = { path: '/users', value: [ user.id, user.email ] } if Config::SECURE
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
      if Config::SECURE
        authenticate_with_cookie( *remember_token )
      else
        authenticate_with_cookie( remember_token )
      end
    end

    def remember_token
      if Config::SECURE
        cookies.signed[:remember_token] || [nil, nil]
      else
        cookies[:remember_token] || nil
      end
    end
end
