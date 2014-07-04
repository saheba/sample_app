require 'spec_helper'

describe Micropost do
  let (:user) { FactoryGirl.create(:user)}
  before do
    @post = Micropost.new(content: 'testpost', user_id: user.id)
  end

  subject { @post }

  it { should respond_to(:content)}
  it { should respond_to(:user_id)}
  it { should respond_to(:created_at)}
  it { should respond_to(:updated_at)}

  describe "when user_id is not valid" do
    before { @post.user_id = nil }
    it { should_not be_valid }
  end
end
