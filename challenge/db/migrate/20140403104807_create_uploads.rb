class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :creator, index: true
      t.attachment :file

      t.timestamps
    end
  end
end
