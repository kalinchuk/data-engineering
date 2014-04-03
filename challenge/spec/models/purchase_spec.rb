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
#  upload_id      :integer
#

describe Purchase do
  describe "creation" do
    subject { create(:purchase) }

    it { should belong_to :upload }
    it { should belong_to :purchaser }
    it { should belong_to :item }
    it { should belong_to :merchant }
    it { should validate_presence_of :upload_id }
    it { should validate_presence_of :purchaser_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :purchase_count }
    it { should validate_numericality_of(:purchase_count).is_greater_than(0) }
  end

  describe "calculations" do
    let!(:purchase_1) { create(:purchase) }
    let!(:purchase_2) { create(:purchase) }

    describe "subtotal" do
      subject { Purchase.subtotal }

      it { should eq purchase_1.item.price + purchase_2.item.price }
    end

    describe "gross" do
      subject { Purchase.gross }

      it { should eq (purchase_1.item.price + purchase_2.item.price) * (purchase_1.purchase_count + purchase_2.purchase_count) }
    end
  end
end
