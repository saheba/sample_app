require 'spec_helper'

describe User do
  before { @user = User.new(name:'Exp1',email:'exp1@ror.com') }

  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
end
