# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    purchaser_name { Faker::Name.name }
    item_description { Faker::Lorem.paragraph }
    item_price { rand(100.0) }
    purchase_count { rand(10) }
    merchant_address { Faker::Address.street_address }
    merchant_name { Faker::Company.name }
  end
end
