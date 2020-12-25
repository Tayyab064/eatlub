require 'open-uri'
require 'nokogiri'


unless cuserres = User.find_by_email('muhammad.tayyab@eatlub.com')
  cuserres = User.create(name: 'M Tayyab' , username: 'tayyab' , email: 'muhammad.tayyab@eatlub.com', gender: 0, role: 1, verified: true, password: '123456', mobile_number: '3339214785')
end

unless ghgvs = User.find_by_email('admin@eatlub.com')
  ghgvs = User.create(name: 'M Tayyab' , username: 'tayyab' , email: 'admin@eatlub.com', gender: 0, role: 3, verified: true, password: '123456', mobile_number: '3339214785')
end

0.times do
  getrestautas = Nokogiri::HTML(open("https://deliveroo.co.uk/breakfast-takeaway"))
  getrestautas.css('.link-list__links ul li').each do |cit|
    getcitie = Nokogiri::HTML(open("https://deliveroo.co.uk/breakfast-takeaway/#{cit.text.downcase.gsub(' ', '-')}"))
    getcitie.css('.link-list__links  ul li').each do |pcit|
      restmenu = Nokogiri::HTML(open("https://deliveroo.co.uk/restaurants/#{cit.text.downcase.gsub(' ', '-')}/#{pcit.text.downcase.gsub(' ', '-')}"))
      restmenu.css('.restaurant-index-page-tile').each do |restlink|
        doc = Nokogiri::HTML(open("https://deliveroo.co.uk/#{restlink.css('a')[0]['href'].split('?')[0]}"))
        p "https://deliveroo.co.uk/#{restlink.css('a')[0]['href'].split('?')[0]}"
        dat = doc.css('.menu-index-page')
        rest_dest = dat.css('.restaurant__details')
        restaurant_name = rest_dest.css('.restaurant__name').text
        restaurant_description = ''
        if rest_dest.css('.restaurant__description .truncate-text span')[0].present?
          restaurant_description = rest_dest.css('.restaurant__description .truncate-text span')[0].text
        end
        deta = rest_dest.css('.restaurant__metadata .metadata__details')
        #p deta.css('.food').text
        #restaurant_address = deta.css('.address').text
        restaurant_address = 'Downtown Dubai - Dubai - United Arab Emirates'
        #restaurant_phone = deta.css('.phone').text
        restaurant_phone = '+971 800 382246255'
        restaurant_time = deta.css('.opening-hours').text.split(' ').last

        if c = Deliverable.find_by_name(restaurant_name)
          p c
          p restaurant_address
          if c.branches.find_by_address(restaurant_address)
            p 'find'
          else
            Branch.create(address: restaurant_address,deliverable_id: c.id)
          end
        else
          unless sde = DeliverCategory.find_by_name('restaurant')
            DeliverCategory.create(name: 'restaurant' , description: 'Favour restaurant')
          end

          deliceer = Deliverable.create(name: restaurant_name,opening_time: restaurant_time,closing_time: '12:00 am',owner_id: cuserres.id ,status: 1,about_us: restaurant_description ,delivery_fee: 2.5,phone_number: restaurant_phone ,deliver_category_id:  sde.id)
          p deliceer
          Branch.create(address: restaurant_address,deliverable_id: deliceer.id)
          deliverable_menu = Menu.create(title: 'Menu' ,menuable_id: deliceer.id,menuable_type: 'Deliverable')
          p deliverable_menu
           
          dat.css('.menu-index-page__menu-category').each do |ls|
            restaurant_section = Section.create(title: ls.css('h3')[0].text ,menu_id: deliverable_menu.id )
            p restaurant_section
            ls.css('.menu-index-page__item .menu-index-page__item-content').each do |sd|
              foodtitle =  sd.css('.menu-index-page__item-title').text
              fooddesc = sd.css('.menu-index-page__item-desc').text
              foodprice = sd.css('.menu-index-page__item-price').text.split('£')[1].to_f
              FoodItem.create(name: foodtitle,price: foodprice,section_id: restaurant_section.id,description: fooddesc)
            end
          end
        end
      end
    end
  end
end

