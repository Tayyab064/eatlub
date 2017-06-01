require 'open-uri'
require 'nokogiri'

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
        restaurant_address = deta.css('.address').text
        restaurant_phone = deta.css('.phone').text
        restaurant_time = deta.css('.opening-hours').text.split(' ').last

        if c = Deliverable.find_by_name(restaurant_name)
          p c
          p restaurant_address
          if c.branches.find_by_address(restaurant_address)
            p 'find'
          else
            Branch.create(address: restaurant_address,post_code: restaurant_address.split(' ').last,deliverable_id: c.id)
          end
        else
          if sde = DeliverCategory.find_by_name('restaurant')
            deliceer = Deliverable.create(name: restaurant_name,opening_time: restaurant_time,closing_time: '12:00 am',owner_id: 542,status: 1,about_us: restaurant_description ,delivery_fee: 2.5,phone_number: restaurant_phone ,deliver_category_id:  sde.id)
            p deliceer
            Branch.create(address: restaurant_address,post_code: restaurant_address.split(' ').last,deliverable_id: deliceer.id)
            deliverable_menu = Menu.create(title: 'Menu' ,menuable_id: deliceer.id,menuable_type: 'Deliverable')
            p deliverable_menu
          end
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

des = Deliverable.find(1433)
if des.menu.nil?
  Menu.create(title: 'Menu', menuable_id: 1433, menuable_type: 'Deliverable')
end

CSV.foreach("/home/holygon/deliverush/public/1433.csv") do |row|
  unless sec = Section.find_by_title(row[0])
    sec = Section.create(title: row[0] , menu_id: des.menu.id)
  end

  FoodItem.create(name: row[1], price: row[2], section_id: sec.id)
end