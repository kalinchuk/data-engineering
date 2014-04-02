describe Purchaser do
  describe "creation" do
    let(:creation_attributes) {{
      name: Faker::Name.name
    }}

    subject { Purchaser.create(creation_attributes) }

    describe "validations" do
      it "accepts a purchaser with all attributes" do
        expect(subject).to be_valid
      end

      it "rejects a purchaser without a name" do
        creation_attributes.delete :name
        expect(subject).not_to be_valid
      end

      it "accepts a purchaser from a factory" do
        expect(create(:purchaser)).to be_valid
      end
    end

    describe "associations" do
      it "has many purchases" do
        purchase = create(:purchase, purchaser: subject)
        expect(subject.purchases).to include purchase
        expect(purchase.purchaser).to eq subject
      end
    end
  end
end