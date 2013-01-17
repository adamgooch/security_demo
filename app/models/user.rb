class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password_digest

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :uniqueness => { :case_sensitive => false },
                    :presence => { :message => "Your email is used to save your greeting." },
                    :format => { :with  => email_regex }
  validates_presence_of :password_digest
end
