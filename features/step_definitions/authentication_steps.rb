require 'factory_girl'
require 'rspec/expectations'

RSpec::Matchers.define :have_error_message do |msg|
	match do |page|
		expect(page).to have_selector('div.alert.alert-error', text: msg)
	end
end

Given /^a user visits the signin page$/ do
  # subject { page } ## does not work in cucumber

  # plain capybara (included by default in cc step files like this one)
  visit signin_path
end

When /^they submit invalid signin information$/ do
  click_button 'Sign in'
end

Then /^they should see an error message$/ do
  expect(page).to have_error_message('Invalid')
end


Given /^the user has an account$/ do
	@user = FactoryGirl.create(:user)
end

When /^they submit valid signin information$/ do
	fill_in "Email", with: @user.email
	fill_in "Password", with: @user.password
	click_button 'Sign in'
end

Then /^they should see their profile page$/ do
	expect(page).to have_title(@user.name)
end

And /^they should see a signout link$/ do
	expect(page).to have_link('Sign out', href: signout_path)
end
