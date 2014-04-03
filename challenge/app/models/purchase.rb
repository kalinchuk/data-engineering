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
#  upload_id      :integer
#

# This class represents a purchase made by a purchaser.
class Purchase < ActiveRecord::Base
  # @!group Attributes

  # @!attribute purchase_count
  # The number of items that were purchased.
  # @return [Integer]

  # @!group Associations

  # @!attribute upload
  # The upload that created the purchase.
  # @return [Upload]
  belongs_to :upload

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
  
  validates_presence_of :upload_id, :purchaser_id, :item_id, :merchant_id, :purchase_count
  validates_numericality_of :purchase_count, greater_than: 0

  # @!group Calculations

  # This method gets the subtotal for the purchases.
  #
  # @return [Float]
  def self.subtotal
    includes(:item).sum('items.price')
  end

  # This method gets the gross total for the purchases.
  #
  # @return [Float]
  def self.gross
    includes(:item).sum('items.price') * sum(:purchase_count)
  end
end
