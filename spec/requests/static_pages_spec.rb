require 'spec_helper'

describe "static pages" do
  describe "home page" do
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
  end

  describe "help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
  end

  describe "about page" do
  	it "should have the content 'About Us'" do
  		visit 'static_pages/about'
  		expect(page).to have_content('About Us')
  	end
  end
end
