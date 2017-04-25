# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Vendor.destroy_all
Market.destroy_all
MarketImage.destroy_all
MarketReview.destroy_all
Store.destroy_all
StoreMarketRelationship.destroy_all
StoreImage.destroy_all
StoreReview.destroy_all
ShoppingList.destroy_all
Product.destroy_all
ProductImage.destroy_all
Subscription.destroy_all


firstnames = ["Abigail", "Bill", "Ike", "George", "Jake", "Christina", "Max", "Thomas", "Sarah", "Daisy", "Delila", "Rose"]
lastnames = ["Smith", "Arrow", "House", "Levin", "Woolf", "Hunt", "Roth", "Zhang", "Amami", "Spinner-Reyes"]



puts "creating sample users and vendors"
i = 0
50.times do
  name = firstnames.sample + " " + lastnames.sample
  email = name[0,3] + i.to_s  + "@gmail.com"
  @user = User.create!(name: name, email: email, zipcode: "02453", city: "Waltham", state: "MA", password: "123456", password_confirmation: "123456")
  if i > 25
    @vendor = Vendor.create!(user_id: @user.id)
  end
  i = i + 1
end

puts "creating markets"

  @users = User.offset(1)

  @user = @users.first
  name = "Central Square Farmers Market"
  description = ""
  @market = @user.markets.create!(name: name,
  city: "Cambridge",
  state: "MA",
  zipcode: "02139",
  rating: "1",
  address: "Bishop Allen Drive at Norfolk Street",
  description: @user.name + "'s Market:" + description,
  open_time: 43200,
  close_time: 64800)
  10.times do
    @user = User.offset(rand(User.count)).first
    if @user.id != @market.user_id
      MarketReview.create!(rating: [1, 2, 3, 4, 5].sample,
      comment: i.to_s + " test review",
      user_id: @user.id,
      market_id: @market.id)
    end
  end

  @user = @users.second
  name = "Waltham Farmers Market"
  description = "We are in the Arthur J. Clark Government Building."
  @market = @user.markets.create!(name: name,
  city: "Waltham",
  state: "MA",
  zipcode: "02452",
  rating: "1",
  address: "119 School Street, at Lexington Street",
  description: @user.name + "'s Market:" + description,
  open_time: 5*86400+9*3600+30*60,
  close_time: 5*86400+43200+2*3600)
  10.times do
    @user = User.offset(rand(User.count)).first
    if @user.id != @market.user_id
      MarketReview.create!(rating: [1, 2, 3, 4, 5].sample,
      comment: i.to_s + " test review",
      user_id: @user.id,
      market_id: @market.id)
    end
  end

  @user = @users.third
  name = "Framingham / Village Green Farmers Market"
  description = "Pay with:\nCash\nSNAP / EBT \nEBTWIC FMNP Coupons WIC\nWIC Fruit & Veg Coupons\nSeniors' Coupons\nCredit Cards"
  @market = @user.markets.create!(name: name,
  city: "Framingham",
  state: "MA",
  zipcode: "01760",
  rating: "1",
  address: "Village Green at Framingham Center",
  description: @user.name + "'s Market:" + description,
  open_time: 3*86400+43200,
  close_time: 3*86400+43200+5*3600+30*60)
  10.times do
    @user = User.offset(rand(User.count)).first
    if @user.id != @market.user_id
      MarketReview.create!(rating: [1, 2, 3, 4, 5].sample,
      comment: i.to_s + " test review",
      user_id: @user.id,
      market_id: @market.id)
    end
  end


products = ["Spice Shop", "Brewery", "Store", "Butchery", "Cheeses", "Bakery", "Cafe", "Farmstand", "Deli", "Fruit Stand", "Fruit Stand", "Fruit Stand", "Fruit Stand", "Fruit Stand", "Seafood", "Steaks", "Garden", "Vegetables", "Garden", "Vegetables", "Garden"]
adjectives = ["Fresh", "Red", "Gluten-free", "Nike", "Moldy"]
item = ["White Button Mushrooms", "Portobello Mushrooms", "Yuka", "Idaho Potatoes", "Eggplant", "Lima Beans", "Garlic", "Red Onion", "Vidalia Onion", "Sweet Onion", "Tomato", "Oregano" , "Basil", "Cilantro", "Orange Bell Pepper", "Yellow Bell Pepper", "Red Bell Pepper", "Green Bell Pepper", "Sesame Bagels", "Asiago Bread Loaf", "Flour", "Corn", "Spinach", "Carrots", "Bokchoy", "Broccoli", "Lobster", "Cod", "Tuna", "Shark", "Salmon", "Kiwi", "Golden Delicious Apple", "Fiji Apple" ,"Granny Smith Apple", "Parmesan 5 yr", "Muenster", "Cheddar", "Mozarella", "Pineapple", "Honeydew", "Canteloupe", "Watermelon", "Bananas", "Mandarin Oranges", "Blood Oranges", "Strawberries", "Blueberries", "Raspberries", "Beer", "Cider", "Tenderloin", "Pork Chops", "Chicken Breast", "Chicken Wings", "NY Strip", "T-Bone Steak", "Lamb Chop"]
tags = ["spice", "no-carb", "organic", "gluten-free", "soy-free", "vegetarian", "berry", "peanuts", "seafood", "meat", "dairy", "carb", "cheese", "fruit", "vegetable"]
puts "creating stores"
Vendor.all.each do |vendor|

  marketid = rand() > 0.66 ? Market.all.first.id : rand() > 0.5 ? Market.all.second.id : Market.all.third.id

  @store = Store.create!(name: (User.find(vendor.user_id).name + "'s " + products.sample),
  description: "test store",
  vendor_id: vendor.id)

  @store.store_market_relationships.create!(market_id: marketid,
  open_time: Market.find(marketid).open_time+1800*rand(3),
  close_time: Market.find(marketid).close_time-1800*rand(3),)

  @store.requests.create!(market_id: marketid,
  open_time: Market.find(marketid).open_time+1800*rand(3),
  close_time: Market.find(marketid).close_time-1800*rand(3),
  status: (rand() > 0.5 ? 5 : 6))

  5.times do
  name = item.sample
  price = "$"+((4+rand(6))*0.5).to_s+"/lb"
  Product.create!(name: name,
  price: price,
  description: "test product",
  tag: tags.sample+","+tags.sample,
  store_id: @store.id)
  end

  10.times do
    @user = User.offset(rand(User.count)).first
    product = products.sample
    StoreReview.create!(rating: [1, 2, 3, 4, 5].sample,
    comment: "test store review",
    user_id: @user.id,
    store_id: @store.id)
  end
end

p "Created #{User.count} users"
p "Created #{Market.count} markets"
p "Created #{Vendor.count} vendors"
p "Created #{Store.count} stores"
p "Created #{Product.count} products"
