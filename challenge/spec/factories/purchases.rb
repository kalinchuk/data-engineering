# == Schema Information
#
# Table name: purchases
#
#  id             :integer          not null, primary key
#  purchaser_id   :integer
#  item_id        :integer
#  merchant_id    :integer
#  purchase_count :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    purchaser
    item
    merchant
    purchase_count { rand(10) }
  end
end
