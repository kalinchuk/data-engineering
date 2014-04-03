# == Schema Information
#
# Table name: merchants
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# This class represents a merchant that sells items.
class Merchant < ActiveRecord::Base
  # @!group Attributes

  # @!attribute name
  # The name of the merchant.
  # @return [String]

  # @!attribute address
  # The address of the merchant.
  # @return [String]

  # @!group Associations

  # @!attribute items
  # The items the merchant sells.
  # @return [Relation<Item>]
  has_many :items

  # @!group Validations

  validates_presence_of :name, :address
end
