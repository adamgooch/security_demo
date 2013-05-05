module AuthenticationHelper

  def authenticate( email, submitted_password )
    user = User.find_by_email( email.downcase )
    ( user && user.password_digest == encrypt_password( submitted_password, user.salt ) ) ? user : nil
  end

  def authenticate_with_cookie( id, email = nil )
    user = User.find_by_id( id )
    if RbConfig::SECURE
      user && user.email == email ? user : nil
    else
      user ? user : nil
    end
  end

  def encrypt_password( plain_text, salt )
    return plain_text unless RbConfig::SECURE
    derived_key = PBKDF2.new do |key|
      key.password = plain_text
      key.salt = salt
      key.iterations = 10000
    end
    return derived_key.hex_string
  end

  def make_salt
    return SecureRandom.hex( 32 )
  end

  def login( user )
    cookies[:remember_token] = user.id unless RbConfig::SECURE || RbConfig::SSL
    cookies.signed[:remember_token] = { secure: true, value: [ user.id, user.salt ] } if RbConfig::SSL
    cookies.signed[:remember_token] = { value: [ user.id, user.email ] } if RbConfig::SECURE
    #cookies.signed[:remember_token] = { path: '/users', value: [ user.id, user.email ] } if RbConfig::SECURE
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
      if RbConfig::SECURE
        authenticate_with_cookie( *remember_token )
      else
        authenticate_with_cookie( remember_token )
      end
      #authenticate_with_cookie( session[:user_id] )
    end

    def remember_token
      if RbConfig::SECURE
        cookies.signed[:remember_token] || [nil, nil]
      else
        cookies[:remember_token] || nil
      end
    end
end
