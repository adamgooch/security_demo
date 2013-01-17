class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password_digest

  validates_presence_of :email
  validates_presence_of :password_digest
end
