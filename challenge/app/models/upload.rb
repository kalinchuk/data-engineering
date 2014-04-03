# == Schema Information
#
# Table name: uploads
#
#  id                :integer          not null, primary key
#  creator_id        :integer
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

require 'csv'

# This class represents a file that was uploaded.
class Upload < ActiveRecord::Base
  # @!group Associations

  # @!attribute creator
  # The user that uploaded the file.
  # @return [User]
  belongs_to :creator, class_name: 'User'

  # @!attribute purchases
  # The purchases in this upload.
  # @return [Relation<Purchase>]
  has_many :purchases

  has_attached_file :file, url: "/imported_files/:attachment_:id.tab"

  # @!group Validations

  validates_presence_of :creator_id
  validates_attachment :file, presence: true, content_type: { content_type: ['application/octet-stream', 'text/plain'] }
  validates_attachment_size :file, in: 0..10.megabytes

  # @!group Importing

  # This method imports the uploaded file and creates the purchases
  # and the dependencies.
  #
  # @return [Boolean]
  def import!
    transaction do
      CSV.foreach(file.path, col_sep: "\t", return_headers: false, headers: true) do |row|
        purchaser = Purchaser.find_or_create_by!(name: row['purchaser name'])
        merchant = Merchant.find_or_create_by!(name: row['merchant name'], address: row['merchant address'])
        item = Item.find_or_create_by!(merchant: merchant, description: row['item description'], price: row['item price'].to_f)
        purchases.create!(purchaser: purchaser, merchant: merchant, item: item, purchase_count: row['purchase count'].to_i)
      end
      true
    end
  end
end
