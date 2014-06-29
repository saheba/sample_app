require 'spec_helper'

describe User do
  before { @user = User.new(name:'Exp1',email:'exp1@ror.com',
  	password: 'foobar', password_confirmation: 'foobar') }

  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  it { should be_valid }

  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when password is not present" do
  	before do
  	 @user.password = " "
  	 @user.password_confirmation = " "
  	end
  	it { should_not be_valid }
  end

  describe "when password does not match confirmation" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }
  end

  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) { User.find_by(email: @user.email) }

  	describe "with valid password" do
  		it { should eq found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  		let(:inval_user) { found_user.authenticate("inval") }
  		it { should_not eq inval_user }
  		specify { expect(inval_user).to be_false }
  	end
  end

  describe "when password is too short" do
		before { @user.password == @user.password_confirmation = "a"*5 }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
		before { @user.name = "a"*101 }
  	it { should_not be_valid }
  end  	

  describe "when email format is invalid" do
  	it "should be invalid" do
  		addr = %w[	user@foo,com user_at_foo.org 
  								example.user@foo. foo@bar_baz.com
  								foo@bar+baz.com foo@bar..com]
			addr.each do |add|
				@user.email = add
				expect(@user).not_to be_valid
			end  								
  	end
  end

  describe "when email format is valid" do
  	it "should be invalid" do
  		addr = %w[	user@foo.COM A_US-ER@f.oo.org 
  								example.user@foo.jp foo+f@barbaz.cn]
			addr.each do |add|
				@user.email = add
				expect(@user).to be_valid
			end  								
  	end
  end

  describe "when email add is already taken" do
  	before do
  		userdup = @user.dup
  		userdup.email.upcase!
  		userdup.save
  	end

  	it { should_not be_valid }
  end

  describe "when email contains uppercase chars" do
  	before do
  		@user.email = "WHATEVER@ror.COM"
  		@user.save
  	end
    it "should be converted to lowercase" do
    	reloaded = User.find_by(name: 'Exp1')
    	expect(reloaded.email).to eq "whatever@ror.com"
    end
  end

  describe "remember_token" do
    before { @user.save }
    its(:remember_token) { shhould_not be_blank }
    # equivalent to:
    # it { expect(@user.remember_token).not_to be blank }
  end
  
end
