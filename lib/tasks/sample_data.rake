namespace :db do
  desc 'Fill db with sample data'
  task populate: :environment do
    199.times do |n|
      name = Faker::Name.name
      email = "exp"+n.to_s+"@example.com"
      role = (n==10) ? 'admin' : 'role'
      User.create!(name: name,
      email: email,
      password: "foobar",
      password_confirmation: "foobar", role: role)
    end

    users_with_posts = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users_with_posts.each { |user| user.microposts.create!(content: content) }
    end
  end
end
