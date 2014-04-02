# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    description { Faker::Lorem.paragraph }
    price { rand(100.0) }
  end
end
