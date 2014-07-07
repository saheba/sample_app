class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  validates :name, presence: true, length: { maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  ## assigning block to callback hook
  before_save { self.email.downcase! }
  has_secure_password
  ## assigning block to callback hook with method reference
  before_create :create_remember_token

  def admin?
    return self.role == 'admin'
  end

  def new_remember_token
    return SecureRandom.urlsafe_base64()
  end

  def User.digest(token)
    return Digest::SHA1.hexdigest(token.to_s)
  end

  private

	  def create_remember_token
	    ## could it also be: @remember_token?
	    self.remember_token = User.digest(new_remember_token())
	  end
end
