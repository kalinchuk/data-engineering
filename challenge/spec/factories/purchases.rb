# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    purchaser
    item
    merchant
    purchase_count { rand(10) }
  end
end
