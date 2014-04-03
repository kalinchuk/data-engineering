describe "purchases/index.html.haml" do
  let(:user) { create(:user) }
  let!(:purchase_1) { create(:purchase) }
  let!(:purchase_2) { create(:purchase) }

  before do
    view.stub current_user: user
    view.stub purchases: Purchase.all
    render
  end

  it "has the purchaser's name" do
    expect(rendered).to include purchase_1.purchaser.name
  end

  it "has the merchant's name" do
    expect(rendered).to include purchase_1.merchant.name
  end

  it "has the merchant's address" do
    expect(rendered).to include purchase_1.merchant.address
  end

  it "has the item's description" do
    expect(rendered).to include purchase_1.item.description
  end

  it "has the purchase count" do
    expect(rendered).to include purchase_1.purchase_count.to_s
  end

  it "has the items's price" do
    expect(rendered).to include number_to_currency(purchase_1.item.price)
  end

  it "has the subtotal" do
    expect(rendered).to include(number_to_currency(subtotal(Purchase.all)))
  end

  it "has the gross total" do
    expect(rendered).to include(number_to_currency(gross(Purchase.all)))
  end
end
