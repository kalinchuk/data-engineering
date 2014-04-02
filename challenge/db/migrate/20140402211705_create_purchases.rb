class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :purchaser
      t.references :item
      t.references :merchant
      t.int :purchase_count

      t.timestamps
    end
  end
end
