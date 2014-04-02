describe Purchase do
  describe "creation" do
    let(:creation_attributes) {{
      purchaser_name: Faker::Name.name,
      item_description: Faker::Lorem.paragraph,
      item_price: 55.50,
      purchase_count: 5,
      merchant_address: Faker::Address.street_address,
      merchant_name: Faker::Company.name
    }}

    subject { Purchase.create(creation_attributes) }

    describe "validations" do
      it "accepts a purchase with all attributes" do
        expect(subject).to be_valid
      end

      it "rejects a purchase without a purchaser name" do
        creation_attributes.delete :purchaser_name
        expect(subject).not_to be_valid
      end

      it "accepts a purchase without an item description" do
        creation_attributes.delete :item_description
        expect(subject).to be_valid
      end

      it "rejects a purchase without an item price" do
        creation_attributes.delete :item_price
        expect(subject).not_to be_valid
      end

      it "rejects a purchase with an item price less than 1" do
        creation_attributes[:item_price] = 0
        expect(subject).not_to be_valid
      end

      it "rejects a purchase without a purchase count" do
        creation_attributes.delete :purchase_count
        expect(subject).not_to be_valid
      end

      it "rejects a purchase with a purchase count less than 1" do
        creation_attributes[:purchase_count] = 0
        expect(subject).not_to be_valid
      end

      it "rejects a purchase without a merchant address" do
        creation_attributes.delete :merchant_address
        expect(subject).not_to be_valid
      end

      it "rejects a purchase without a merchant name" do
        creation_attributes.delete :merchant_name
        expect(subject).not_to be_valid
      end

      it "accepts a purchase from a factory" do
        expect(create(:purchase)).to be_valid
      end
    end
  end
end
