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
  			# UsersController.user_params ensures this (see Hartl section 7.3.2)
  			expect { click_button submit }.not_to change(User, :count)
  	  end  		
  	  
      describe "after sub" do 
        before { click_button submit } ## happens before each it-block?
        it { should have_selector('div', text: 'The form contains 6 errors.') }
    		it { should have_selector('li', text: "* Name can't be blank") }
    		it { should have_selector('li', text: "* Email can't be blank") }
    		it { should have_selector('li', text: "* Password is too short (minimum is 6 characters)") }
      end
  		
  	end

  	describe "with valid information" do
  		before do
  			fill_in "Name", with: "Example User"
  			fill_in "Email", with: "foo@bar.com"
  			fill_in "Password", with: "foobar"
  			fill_in "Confirmation", with: "foobar"
        ## happens once before it-block and once again before describe-block
  		end
  		it "should create a user" do
  			expect { click_button submit }.to change(User, :count).by(1)
  		end  

      describe "after saving the user" do
        # why do we have to perform the button click again? 
        # > because it describes another example which is not related to this one.
        before { click_button submit }
        it { should have_title(full_title('Example User')) }
      end
  	end
  end
end
