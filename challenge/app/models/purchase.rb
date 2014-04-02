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

# This class represents a purchase made by a purchaser.
class Purchase < ActiveRecord::Base
  # @!group Attributes

  # @!attribute purchase_count
  # The number of items that were purchased.
  # @return [Integer]

  # @!group Associations

  # @!attribute purchaser
  # The purchaser who made the purchase.
  # @return [Purchaser]
  belongs_to :purchaser

  # @!attribute item
  # The item that was purchased.
  # @return [Item]
  belongs_to :item

  # @!attribute merchant
  # The merchant that sold the item.
  # @return [Merchant]
  belongs_to :merchant

  # @!group Validations
  
  validates :purchaser, presence: true
  validates :item, presence: true
  validates :merchant, presence: true
  validates :purchase_count, presence: true, numericality: { greater_than: 0 }
end
