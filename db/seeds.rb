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
