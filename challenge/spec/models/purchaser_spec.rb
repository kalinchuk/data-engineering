# == Schema Information
#
# Table name: purchasers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

describe Purchaser do
  describe "creation" do
    subject { create(:purchaser) }

    it { should have_many(:purchases) }
    it { should validate_presence_of :name }
  end
end
