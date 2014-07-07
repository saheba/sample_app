require 'spec_helper'

describe Micropost do
  let (:user) { FactoryGirl.create(:user)}
  before do
    #@post = Micropost.new(content: 'testpost', user_id: user.id)
    @post = user.microposts.build(content: 'testpost')
  end

  subject { @post }

  it { should respond_to(:content)}
  it { should respond_to(:user_id)}
  it { should respond_to(:created_at)}
  it { should respond_to(:updated_at)}
  it { should respond_to(:user)}
  its (:user) { should eq user }

  describe "when user_id is not valid" do
    before { @post.user_id = nil }
    it { should_not be_valid }
  end

  describe "when content is blank" do
    before { @post.content = " " }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    before { @post.content = "a" * 141 }
    it { should_not be_valid }
  end
end
