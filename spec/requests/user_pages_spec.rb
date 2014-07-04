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
        let(:user) { User.find_by(email: "foo@bar.com") }

        it { should have_link('Sign out') }
        it { should have_title(full_title('Example User')) }
        it { should have_selector('div.alert.alert-success', 'Welcome :)') }
      end
  	end
  end

	describe "as signed-in user" do
		let!(:user) { FactoryGirl.create(:user) }
		before do

		end
		describe "sign up page should not be available" do
				before do
					sign_in user
					visit new_user_path
				end
				it { should_not have_title("#{base_title} | Signup") }
		end

		describe "sign up action should not be accessible" do
			before do
				sign_in user, no_capybara: true
				get new_user_path
			end
			specify { expect(response).to redirect_to(root_path) }
		end

		describe "create user action should not be accessible" do
			before do
				 sign_in user, no_capybara: true
				 post users_path
			end
			specify { expect(response).to redirect_to(root_path) }
		end
	end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content('Update your profile') }
      it { should have_title('Edit user') }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
        click_button "Save changes"
      end

        it { should have_link('Sign out', href: signout_path) }
        it { should have_title(full_title(new_name)) }
        it { should have_selector('div.alert.alert-success', 'Welcome :)') }
        specify { expect(user.reload.name).to eq new_name }
        specify { expect(user.reload.email).to eq new_email }
    end
  end

	describe "delete user" do
		# not logged in
		it { should_not have_link('delete') }

		# logged in as normal user
		describe "should not be possible as normal user" do
			let(:user2) { FactoryGirl.create(:user) }
			before do
				sign_in user2
				visit users_path
			end

			it { should have_no_link('delete')}
		end

		# logged in as admin
		describe "should be a visible link as admin" do
			#before do
			#	@admin = FactoryGirl.create(:admin, name: "Bob", email: "bob@example.com")
			#end
			let (:admin) { FactoryGirl.create(:admin) }
			before do
				FactoryGirl.create(:user)
				#binding.pry
				sign_in admin
				visit users_path
				#binding.pry
			end

			it { should have_link('delete', href: user_path(User.first)) }
		it "should be performable as admin" do
				expect do
					click_link('delete', match: :first)
				end.to change(User, :count).by(-1)
			end
			it { should have_no_link('delete', href: user_path(admin)) }
		end

	end
end
