require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "sign in" do
    before { visit signin_path }
    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
    it { should have_button('Sign in') }


    describe "with invalid information" do
      it { should have_no_link('Settings') }

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
      before { sign_in user }
      describe "after successful sign in" do
        ## parsing for content as long as we do finally know how the page layout will look like
        it { should have_no_link('Sign in', href: signin_path) }
        it { should have_link('Sign out', href: signout_path ) }
        it { should have_link('Profile', href: user_path(user)) }
        it { should have_link('Settings', href: edit_user_path(user)) }

        describe "a sign out should succeed" do
        	before { click_link 'Sign out'}
        	it { should have_link('Sign in') }
        	it { should have_no_link('Sign out') }          
        end
      end
    end
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) } #gets routed to UsersController.update
          specify { expect(response).to redirect_to(signin_path) }
        end

      end
    end
  end
end
