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

require 'csv'

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

  # @!group Importing
  
  class << self

    # This method contains all the fields in the importing file.
    #
    # @return [Array<Symbol>]
    def fields
      [
        :purchaser_name, :item_description, :item_price, 
        :purchase_count, :merchant_address, :merchant_name
      ]
    end

    # This method imports the file and creates purchases along with the
    # dependencies.
    #
    # @param [String] file
    #  The file being imported.
    #
    # @return [Boolean]
    def import(file)
      begin
        transaction do
          self.destroy_all

          CSV.open(file, 'r') do |csv|
            csv.each_with_index do |row,index|
              next if index == 0
              attrs = Hash[row.map.each_with_index{|attribute,index| [fields[index], attribute]}]

              purchaser = Purchaser.find_or_create_by!(name: attrs[:purchaser_name])

              item = Item.find_or_create_by!(description: attrs[:item_description]) do |i|
                i.price = attrs[:item_price].to_f
              end

              merchant = Merchant.find_or_create_by!(name: attrs[:merchant_name]) do |m|
                m.address = attrs[:merchant_address]
              end

              Purchase.create!(
                purchaser: purchaser,
                item: item,
                merchant: merchant,
                purchase_count: attrs[:purchase_count].to_i
              )
            end
          end

          true
        end
      rescue => e
        false
      end
    end

  end
end
