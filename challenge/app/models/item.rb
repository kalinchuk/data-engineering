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

# This class represents an item that a purchaser can purchase.
class Item < ActiveRecord::Base
  # @!group Attributes

  # @!attribute description
  # The description of the item.
  # @return [String]

  # @!attribute price
  # The price of the item.
  # @return [Float]

  # @!group Assocations

  # @!attribute merchant
  # The merchant that owns the item.
  # @return [Merchant]
  belongs_to :merchant

  # @!group Validations

  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
