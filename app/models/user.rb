class User < ActiveRecord::Base
	validates :name, presence: true, length: { maximum: 100 }
	validates :password, presence: true, length: { minimum: 6 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	before_save { self.email.downcase! }
	has_secure_password
end
