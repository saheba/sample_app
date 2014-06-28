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

end
