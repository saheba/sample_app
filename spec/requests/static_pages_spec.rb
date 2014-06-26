require 'spec_helper'

describe "static pages" do
  # include Rails.application.routes.url_helpers
  
  subject { page }
  let(:base_title) { 'RoR Sample App' }
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_page_title) }
  end

  describe "home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:full_page_title) { base_title }

    it_should_behave_like "all static pages"
    it { should_not have_title("Home") }    
  end

  # { 'Help' => ['Help', help_path],
  #   'About Us' => ['About', about_path],
  #   'Contact Us' => ['Contact', contact_path]
  #   }.each do |page_name,page_vars|
  #   describe "o #{page_vars[0]} page" do
  #     visit page_vars[1]
  #     let(:heading) { page_name }
  #     let(:full_page_title) { "#{base_title} | #{page_vars[0]}" }

  #     it_should_behave_like "all static pages"    
  #   end
  # end


  describe "help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:full_page_title) { "#{base_title} | Help" }

    it_should_behave_like "all static pages"    
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
