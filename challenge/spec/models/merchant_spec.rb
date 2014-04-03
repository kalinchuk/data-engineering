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
    subject { create(:merchant) }

    it { should have_many :items }
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
  end
end