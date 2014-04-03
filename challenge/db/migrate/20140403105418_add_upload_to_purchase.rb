class AddUploadToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :upload_id, :integer
  end
end
