# == Schema Information
#
# Table name: purchasers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# This class represents a purchaser.
class Purchaser < ActiveRecord::Base
  # @!group Attributes

  # @!attibute name
  # The name of the purchaser.
  # @return [String]

  # @!group Associations

  # @!attribute purchases
  # The purchases made by the purchaser.
  # @return [Relation<Purchase>]
  has_many :purchases

  # @!group Validations

  validates :name, presence: true
end
