class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :purchaser
      t.references :item
      t.references :merchant
      t.integer :purchase_count, default: 0

      t.timestamps
    end
  end
end
