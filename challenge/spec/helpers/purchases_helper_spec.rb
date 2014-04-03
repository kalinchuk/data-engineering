describe PurchasesHelper do
  let!(:purchase_1) { create(:purchase) }
  let!(:purchase_2) { create(:purchase) }

  describe "subtotal" do
    subject { helper.subtotal(Purchase.all) }

    it "is the total price for the items" do
      expect(subject).to eq purchase_1.item.price + purchase_2.item.price
    end
  end

  describe "gross" do
    subject { helper.gross(Purchase.all) }

    it "is the gross total for the items" do
      expect(subject).to eq(
        (purchase_1.item.price + purchase_2.item.price) * (purchase_1.purchase_count + purchase_2.purchase_count)
      )
    end
  end
end
