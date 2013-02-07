class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :uniqueness => { :case_sensitive => false },
                    :presence => true,
                    :format => { :with  => email_regex, :message => "is improperly formatted. We use the email to uniquely identify you. We will not sell it or send you spam" }
  validates :password, :length => { :minimum => 6 },
                       :presence => true,
                       :confirmation => true
  validates :password_confirmation, :presence => true

  def self.authenticate(email, password)
    user = find_by_email(email.downcase)
    if user && user.password_digest == encrypt_password(password)
      return user
    else
      return nil
    end
  end

  def self.encrypt_password(plain_text)
    plain_text
  end
end
