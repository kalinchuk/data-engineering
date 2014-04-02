# == Schema Information
#
# Table name: merchants
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

describe Merchant do
  describe "creation" do
    let(:creation_attributes) {{
      name: Faker::Name.name,
      address: Faker::Address.street_address
    }}

    subject { Merchant.create(creation_attributes) }

    describe "validations" do
      it "accepts a merchant with all attributes" do
        expect(subject).to be_valid
      end

      it "rejects a merchant without a name" do
        creation_attributes.delete :name
        expect(subject).not_to be_valid
      end

      it "rejects a merchant without an address" do
        creation_attributes.delete :address
        expect(subject).not_to be_valid
      end

      it "accepts a merchant from a factory" do
        expect(create(:merchant)).to be_valid
      end
    end

    describe "associations" do
      it "has many items" do
        item = create(:item, merchant: subject)
        expect(subject.items).to include item
        expect(item.merchant).to eq subject
      end
    end
  end
end