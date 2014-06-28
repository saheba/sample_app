require 'spec_helper'

describe "user pages" do
	subject { page }
	let(:base_title) { 'RoR Sample App' }

  describe "signup page" do
  	before { visit signup_path }
    it { should have_selector('h1', text: 'Sign up') }
    it { should have_title("#{base_title} | Signup") }
  end
  describe "profile page" do
  	let(:user) {FactoryGirl.create(:user)}
  	before { visit user_path(user) }  	
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do
  	before { visit signup_path }
  	let(:submit) { 'Create my account' }

  	describe "with invalid information" do
  		it "should not create a user" do
  			expect { click_button submit }.not_to change(User, :count)
  		end  		
  	end

  	describe "with valid information" do
  		before do
  			fill_in "Name", with: "Example User"
  			fill_in "Email", with: "foo@bar.com"
  			fill_in "Password", with: "foobar"
  			fill_in "Confirmation", with: "foobar"
  		end
  		it "should create a user" do
  			expect { click_button submit }.to change(User, :count).by(1)
  		end  		
  	end
  end
end
