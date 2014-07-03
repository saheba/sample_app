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
        it { should have_link('Users', href: users_path) }
        it { should have_link('Settings', href: edit_user_path(user)) }

        describe "accessing the user list" do
          before do
            FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
            FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
            visit users_path
          end

          it { should have_title('All users')}
          it { should have_content(/all users/)}
          describe "pagination" do
            before(:all) { 30.times { FactoryGirl.create(:user) } }
            after(:all) { User.delete_all }

            it { should have_selector('div.pagination') }
            it "should list each user" do
              User.paginate(page: 1).each do |user|
                expect(page).to have_selector('li', text: user.name)
              end
            end
          end

        end

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
        describe "visiting the user index" do
          before {visit users_path }
          it { should have_title('Sign in') }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
          describe "after signing in" do
            before do
              fill_in "Email", with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it { should have_title('Edit user') }
          end
        end

        describe "submitting to the update action" do
          before { patch user_path(user) } #gets routed to UsersController.update
          specify { expect(response).to redirect_to(signin_path) }
        end

      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user)}
      let(:non_admin) { FactoryGirl.create(:user)}

      before { sign_in non_admin, no_capybara: true}

      describe "submitting a DELTE request to destroy User" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin)}

      before { sign_in admin, no_capybara: true}

      describe "submitting a DELTE request to destroy himself" do
        before { delete user_path(admin) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

      describe "simulated by capybara" do
        before { sign_in user }

        describe "trying to edit other user profile" do
          before { visit edit_user_path(wrong_user)}

           it { should_not have_title(full_title('Edit')) }
           it { should have_no_button('Save changes') }
        end
      end

      describe "using low-level http requests" do
        before { sign_in user, no_capybara: true }

        describe "submitting a GET request to the Users#edit action" do
          before { get edit_user_path(wrong_user) }
          specify { expect(response.body).not_to match(full_title('Edit')) }
          specify { expect(response).to redirect_to(root_url) }
        end
        describe "submitting a PATCH request" do
          # patch must be send directly to the controller root /users
          # instead of sending it to the users/[...]/edit path.
          before { patch user_path(wrong_user) }
          specify { expect(response).to redirect_to(root_url) }
        end
      end
    end
  end
end
