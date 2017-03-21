0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 0 , verified: true)
end

0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 0 , verified: false)
end

0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 0 , verified: true , block: true )
end

0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 1 , verified: true)
  r = Restaurant.create(name: Faker::Name.title , opening_time: Faker::Time.between(DateTime.now - 1, DateTime.now), closing_time: Faker::Time.between(DateTime.now - 1, DateTime.now), location: Faker::Address.country, cuisine: Faker::Company.name, typee: Faker::Company.name, owner_id: c.id)
end

0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 1 , verified: false)
  r = Restaurant.create(name: Faker::Name.title , opening_time: Faker::Time.between(DateTime.now - 1, DateTime.now), closing_time: Faker::Time.between(DateTime.now - 1, DateTime.now), location: Faker::Address.country, cuisine: Faker::Company.name, typee: Faker::Company.name, owner_id: c.id)
end

0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 1 , verified: true , block: true )
  r = Restaurant.create(name: Faker::Name.title , opening_time: Faker::Time.between(DateTime.now - 1, DateTime.now), closing_time: Faker::Time.between(DateTime.now - 1, DateTime.now), location: Faker::Address.country, cuisine: Faker::Company.name, typee: Faker::Company.name, owner_id: c.id)
end

0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 2 , verified: true)
end

0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 2 , verified: false)
end

0.times do |_c|
  c = User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 2 , verified: true , block: true )
end

Restaurant.all.each do |res|
  unless res.menu.present?
    c = Menu.create(title: Faker::Name.title, restaurant_id: res.id)
    5.times do |_sd|
      d = Section.create(title: Faker::Name.title, menu_id: c.id)
      5.times do |_sdf|
        FoodItem.create(name: Faker::Name.title, price: Faker::Number.decimal(2), section_id: d.id)
      end
    end
  end

  0.times do |_df|
    User.create(name: Faker::Name.name , username: Faker::Name.name , email: Faker::Internet.email, gender: 'male' , role: 0 , verified: false)
    rev = Review.create(summary: Faker::Lorem.sentence , quality: Faker::Number.between(1, 5) , price: Faker::Number.between(1, 5) , punctuality: Faker::Number.between(1, 5) , courtesy: Faker::Number.between(1, 5) , restaurant_id: res.id , reviewer_id: User.where(role: 0).last.id)
    rating_tot =  ((rev.quality + rev.price + rev.punctuality + rev.courtesy ).to_f / 4).round
    rev.update(rating: rating_tot)
  end
end


User.where(role: 0).each do |u|
  unless u.wallet.present?
    Wallet.create(user_id: u.id)
  end
end