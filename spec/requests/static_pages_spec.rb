require 'spec_helper'

describe "static pages" do
  describe "home page" do
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title('RoR Sample App | Home')
    end
  end

  describe "help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title('RoR Sample App | Help')
    end
  end

  describe "about page" do
  	it "should have the content 'About Us'" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About Us')
  	end
  	it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title('RoR Sample App | About')
    end
  end
end
