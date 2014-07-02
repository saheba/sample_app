namespace :db do
  desc 'Fill db with sample data'
  task populate: :environment do
    199.times do |n|
      name = Faker::Name.name
      email = "exp"+n.to_s+"@example.com"
      User.create!(name: name,
      email: email,
      password: "foobar",
      password_confirmation: "foobar")
    end
  end
end
