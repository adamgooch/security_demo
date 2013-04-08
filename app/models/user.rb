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
  validates :salt, :presence => true
end
