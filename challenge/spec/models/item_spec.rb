# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  description :string(255)
#  price       :float            default(0.0)
#  created_at  :datetime
#  updated_at  :datetime
#  merchant_id :integer
#

describe Item do
  describe "creation" do
    let(:merchant) { create(:merchant) }
    let(:creation_attributes) {{
      merchant_id: merchant.id,
      description: Faker::Lorem.paragraph,
      price: 55.56
    }}

    subject { Item.create(creation_attributes) }

    describe "validations" do
      it "accepts an item with all attributes" do
        expect(subject).to be_valid
      end

      it "rejects an item without a description" do
        creation_attributes.delete :description
        expect(subject).not_to be_valid
      end

      it "rejects an item without a price" do
        creation_attributes.delete :price
        expect(subject).not_to be_valid
      end

      it "rejects an item with a price at or less than 0" do
        creation_attributes[:price] = 0
        expect(subject).not_to be_valid
      end

      it "accepts an item from a factory" do
        expect(create(:item)).to be_valid
      end
    end

    describe "associations" do
      it "is associated with the merchant" do
        expect(subject.merchant).to eq merchant
      end
    end
  end
end
