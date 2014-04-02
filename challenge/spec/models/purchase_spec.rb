# == Schema Information
#
# Table name: purchases
#
#  id             :integer          not null, primary key
#  purchaser_id   :integer
#  item_id        :integer
#  merchant_id    :integer
#  purchase_count :integer
#  created_at     :datetime
#  updated_at     :datetime
#

describe Purchase do
  describe "creation" do
    let(:purchaser) { create(:purchaser) }
    let(:item) { create(:item) }
    let(:merchant) { create(:merchant) }

    let(:creation_attributes) {{
      purchaser_id: purchaser.id,
      item_id: item.id,
      merchant_id: merchant.id,
      purchase_count: 5
    }}

    subject { Purchase.create(creation_attributes) }

    describe "validations" do
      it "accepts a purchase with all attributes" do
        expect(subject).to be_valid
      end

      it "rejects a purchase without a purchaser" do
        creation_attributes.delete :purchaser_id
        expect(subject).not_to be_valid
      end

      it "rejects a purchase without an item" do
        creation_attributes.delete :item_id
        expect(subject).not_to be_valid
      end

      it "rejects a purchase without a merchant" do
        creation_attributes.delete :merchant_id
        expect(subject).not_to be_valid
      end

      it "rejects a purchase without a purchase count" do
        creation_attributes.delete :purchase_count
        expect(subject).not_to be_valid
      end

      it "accepts a purchase from a factory" do
        expect(create(:purchase)).to be_valid
      end
    end

    describe "associations" do
      it "is associated with the purchaser" do
        expect(subject.purchaser).to eq purchaser
      end

      it "is associated with the item" do
        expect(subject.item).to eq item
      end

      it "is associated with the merchant" do
        expect(subject.merchant).to eq merchant
      end
    end
  end
end
