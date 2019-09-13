User.create!(
            name: "Sang Vo",
            email: "sangvo111@gmail.com",
            password: "123456",
            password_confirmation: "123456",
            admin: true,
            activated: true,
            activated_at: Time.now)

99.times do |n|
  name = Faker::Name.name
  email = "test_user-#{n+1}@test.com"
  password = "123456"
  User.create!(
            name: name,
            email: email,
            password: password,
            password_confirmation: password,
            activated: true,
            activated_at: Time.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each {|user| user.microposts.create!(content: content)}
end

# Following relationship
users = User.all
user = User.find_by email: "sangvo111@gmail.com"
following = users[2..50]
followers = users[3..40]
following.each {|followed| user.follow(followed)}
followers.each {|follower| follower.follow(user)}
