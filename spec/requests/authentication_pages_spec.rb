require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "sign in" do
    before { visit signin_path }
    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
    it { should have_button('Sign in') }


    describe "with invalid information" do

      describe "and after submission" do
        before { click_button 'Sign in' }
        it { should have_selector('div.alert.alert-error') }

        describe "and after visiting another page" do
        	before { click_link "Home" }
        	it { should have_no_selector('div.alert.alert-error') }
        end
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button 'Sign in'
      end
      describe "after sub" do
        ## parsing for content as long as we do finally know how the page layout will look like
        it { should have_no_link('Sign in', href: signin_path) }
        it { should have_link('Sign out', href: signout_path ) }
        it { should have_link('Profile', href: user_path(user)) }
      end
    end
  end
end
