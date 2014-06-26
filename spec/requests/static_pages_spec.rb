require 'spec_helper'

describe "static pages" do
  # include Rails.application.routes.url_helpers
  
  subject { page }
  let(:base_title) { 'RoR Sample App' }
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(full_page_title)) }
  end

  describe "home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:full_page_title) { '' }

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
    let(:full_page_title) { "Help" }

    it_should_behave_like "all static pages"
  end

  describe "about page" do
    before { visit about_path }
  	let(:heading) { 'About Us' }
    let(:full_page_title) { "About" }

    it_should_behave_like "all static pages"
  end

  describe "contact page" do
    before { visit contact_path }
  	let(:heading) { 'Contact Us' }
    let(:full_page_title) { "Contact" }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title("About"))
    click_link "Help"
    expect(page).to have_title(full_title("Help"))
    click_link "Contact"
    expect(page).to have_title(full_title("Contact"))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title("Signup"))
    click_link "sample app"
    expect(page).to have_title(full_title("Signup"))
  end
end
