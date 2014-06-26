require 'spec_helper'

describe "user pages" do
	subject { page }
	let(:base_title) { 'RoR Sample App' }

  describe "signup page" do
  	before { visit signup_path }
    it { should have_content('Sign up') }
    it { should have_title("#{base_title} | Signup") }
  end
end
