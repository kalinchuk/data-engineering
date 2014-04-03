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
    subject { create(:item) }

    it { should belong_to :merchant }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end
end
