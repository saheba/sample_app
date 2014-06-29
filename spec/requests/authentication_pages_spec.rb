require 'spec_helper'

describe "Authentication" do
	subject { page }

  describe "sign in page" do
    before { visit signin_path }
    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  context "with invalid information" do

  	describe "after sub" do 
        before { click_button "Sign in" }
        it { should have_selector('div.alert.alert-error') }
    end
  end

  context "with valid information" do

  	describe "after sub" do 
        before { click_button "Sign in" }
        ## parsing for content as long as we do finally know how the page layout will look like
        it { should_not have_content('Sign in') }
        it { should have_content('Sign out') }
        it { should have_content('Profile') }
    end
  end
end
