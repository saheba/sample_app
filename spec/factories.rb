FactoryGirl.define do
  factory :user do
    sequence (:name) { |n| "person_"+n.to_s }
    sequence (:email) { |n| "person_"+n.to_s+"@example.com" }
    password 'shbshb'
    password_confirmation 'shbshb'
  end
end
