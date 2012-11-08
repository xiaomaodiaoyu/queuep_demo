namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_replies
    make_groups
    make_posts
    make_tokens
  end
end

def make_users
  user = User.create!(first_name: "Example",
                      last_name:  "User",
                      email:    "exampleuser@gmail.com",
                      password: "foobar")
  99.times do |n|
    first_name  = Faker::Name.first_name
    last_name   = Faker::Name.last_name
    email = "example-#{n+1}@gmail.com"
    password  = "password"
    User.create!(first_name: first_name,
                 last_name:  last_name,
                 email:      email,
                 password:   password)
  end
end

def make_groups
  users = User.all(limit: 10)
  2.times do
    users.each do |user|
      name = Faker::Lorem.words(3)
      group = Group.create!(name: name, creator_id: user.id, admin_id: user.id)
      Membership.create!(user_id: user.id, group_id: group.id)
      user_id = user.id + 30
      Membership.create!(user_id: user_id, group_id: group.id)
      another_user_id = user_id + 30
      Membership.create!(user_id: another_user_id, group_id: group.id)
    end
  end
end

def make_posts
  users = User.all(limit: 10)
  50.times do
    group_id = 1 + SecureRandom.random_number(20)
    content = Faker::Lorem.sentence
    users.each { |user| user.posts.create!(group_id: group_id,
                                           content: content) }
  end
end

def make_tokens
  users = User.all(limit: 10)
  users.each { |user| Token.create!(user_id: user.id) }
end

def make_replies
  100.times do |n|
    user_id = 1 + SecureRandom.random_number(100)
    post_id = 1 + SecureRandom.random_number(100)
    content = 1 + SecureRandom.random_number(1000)
    lat     = Faker::Geolocation.lat
    lng     = Faker::Geolocation.lng
    address = Faker::Address.city_prefix + ' ' + Faker::Address.street_address    
    Reply.create!(user_id: user_id,
                  post_id: post_id,
                  content: content,
                  lat:     lat,
                  lng:     lng,
                  address: address)
  end
end



def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end