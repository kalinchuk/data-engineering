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

  describe "importing" do
    describe "import" do
      let(:file) { double }
      let(:file_contents) { [
        ['purchaser name', 'item description', 'item price', 'purchase count', 'merchant address', 'merchant name'],
        ['Snake Plissken', '$10 off $20 of food', 10.0, 2, '987 Fake St', "Bob's Pizza"]
      ]}
      let(:first_purchase) { Purchase.first }
      let(:first_purchaser) { Purchaser.first }
      let(:first_item) { Item.first }
      let(:first_merchant) { Merchant.first }

      subject { Purchase.import(file) }

      before do
        CSV.stub(:open).and_yield(file_contents)
      end

      context "with valid purchases" do
        it "destroys other purchases" do
          expect(Purchase).to receive(:destroy_all)
          subject
        end

        it "opens the CSV file" do
          expect(CSV).to receive(:open).with(file, 'r')
          subject
        end

        it "creates a purchase" do
          subject
          expect(first_purchase).not_to be_nil
          expect(first_purchase.purchaser).to eq first_purchaser
          expect(first_purchase.item).to eq first_item
          expect(first_purchase.merchant).to eq first_merchant
          expect(first_purchase.purchase_count).to eq 2
        end

        it "creates a purchaser" do
          subject
          expect(first_purchaser).not_to be_nil
          expect(first_purchaser.name).to eq 'Snake Plissken'
        end

        it "creates an item" do
          subject
          expect(first_item).not_to be_nil
          expect(first_item.description).to eq '$10 off $20 of food'
          expect(first_item.price).to eq 10
        end

        it "creates a merchant" do
          subject
          expect(first_merchant).not_to be_nil
          expect(first_merchant.name).to eq "Bob's Pizza"
          expect(first_merchant.address).to eq '987 Fake St'
        end

        it "is true" do
          expect(subject).to be_true
        end
      end

      context "with invalid purchases" do
        before do
          file_contents << ['Some purchaser', '', 0, 2, 'Street', 'Company']
        end

        it "opens the CSV file" do
          expect(CSV).to receive(:open).with(file, 'r')
          subject
        end

        it "does not add or delete any purchases" do
          subject
          expect(Purchase.count).to eq 0
        end

        it "is false" do
          expect(subject).to be_false
        end
      end

      context "with an exception" do
        before do
          CSV.stub(:open).and_raise
        end

        it "opens the CSV file" do
          expect(CSV).to receive(:open).with(file, 'r')
          subject
        end

        it "does not add or delete any purchases" do
          subject
          expect(Purchase.count).to eq 0
        end

        it "is false" do
          expect(subject).to be_false
        end
      end
    end
  end
end
