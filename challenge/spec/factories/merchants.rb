# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :merchant do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
  end
end
