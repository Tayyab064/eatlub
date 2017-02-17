5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 0 , verified: true)
end

5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 0 , verified: false)
end

5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 0 , verified: true , block: true )
end

5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 1 , verified: true)
  r = Restaurant.create(name: Faker::Name.title , opening_time: Faker::Time.between(DateTime.now - 1, DateTime.now), closing_time: Faker::Time.between(DateTime.now - 1, DateTime.now), location: Faker::Address.country, cuisine: Faker::Company.name, typee: Faker::Company.name, owner_id: c.id)
end

5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 1 , verified: false)
  r = Restaurant.create(name: Faker::Name.title , opening_time: Faker::Time.between(DateTime.now - 1, DateTime.now), closing_time: Faker::Time.between(DateTime.now - 1, DateTime.now), location: Faker::Address.country, cuisine: Faker::Company.name, typee: Faker::Company.name, owner_id: c.id)
end

5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 1 , verified: true , block: true )
  r = Restaurant.create(name: Faker::Name.title , opening_time: Faker::Time.between(DateTime.now - 1, DateTime.now), closing_time: Faker::Time.between(DateTime.now - 1, DateTime.now), location: Faker::Address.country, cuisine: Faker::Company.name, typee: Faker::Company.name, owner_id: c.id)
end

5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 2 , verified: true)
end

5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 2 , verified: false)
end

5.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 2 , verified: true , block: true )
end