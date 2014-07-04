FactoryGirl.define do
  factory :user do
    sequence (:name) { |n| "person_"+n.to_s }
    sequence (:email) { |n| "person_"+n.to_s+"@example.com" }
    password 'shbshb'
    password_confirmation 'shbshb'
    factory :admin do
      role 'admin'
    end
  end

  factory :micropost do
    content 'testpost'
    ## TODO why does user have to be listed here, but created_at not
    user
  end
end
