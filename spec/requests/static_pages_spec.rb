require 'spec_helper'

describe "static pages" do
  
  subject { page }
  let(:base_title) { 'RoR Sample App' }
  
  describe "home page" do
    before { visit root_path }
    it { should have_selector('h1', text: 'Sample App') }
    it { should have_title("#{base_title}") }
    it { should_not have_title("Home") }    
  end

  describe "help page" do
    before { visit help_path }
    it { should have_selector('h1', text: 'Help') }
    it { should have_title("#{base_title} | Help") }    
  end

  describe "about page" do
    before { visit about_path }
  	it { should have_selector('h1', text: 'About Us') }
    it { should have_title("#{base_title} | About") }    
  end

  describe "contact page" do
    before { visit contact_path }
  	it { should have_selector('h1', text: 'Contact Us') }
    it { should have_title("#{base_title} | Contact") }    
  end
end
