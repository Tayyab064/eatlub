


unless cuserres = User.find_by_email('muhammad.tayyab@eatlub.com')
  cuserres = User.create(name: 'M Tayyab' , username: 'tayyab' , email: 'muhammad.tayyab@eatlub.com', gender: 0, role: 1, verified: true, password: '123456', mobile_number: '3339214785')
end

unless ghgvs = User.find_by_email('admin@eatlub.com')
  ghgvs = User.create(name: 'M Tayyab' , username: 'tayyab' , email: 'admin@eatlub.com', gender: 0, role: 3, verified: true, password: '123456', mobile_number: '3339214785')
end


