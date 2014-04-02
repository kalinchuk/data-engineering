# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  description :string(255)
#  price       :float            default(0.0)
#  created_at  :datetime
#  updated_at  :datetime
#  merchant_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    description { Faker::Lorem.paragraph }
    price { rand(100.0) + 1 }
  end
end
