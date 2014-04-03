# == Schema Information
#
# Table name: uploads
#
#  id                :integer          not null, primary key
#  creator_id        :integer
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

describe Upload do
  describe "creation" do
    subject { create(:upload) }

    it { should belong_to :creator }
    it { should have_many :purchases }
    it { should validate_presence_of :creator_id }
    it { should have_attached_file(:file) }
    it { should validate_attachment_content_type(:file).allowing('text/plain', 'application/octet-stream').rejecting('image/png') }
    it { should validate_attachment_size(:file).less_than(10.megabytes) }
  end

  describe "importing" do
    describe "import!" do
      let(:upload) { create(:upload) }
      let(:file_contents) {{
        'purchaser name' => 'Snake Plissken',
        'item description' => '$10 off $20 of food',
        'item price' => 10.0,
        'purchase count' => 2,
        'merchant address' => '987 Fake St',
        'merchant name' => "Bob's Pizza"
      }}

      let(:first_purchase) { Purchase.first }
      let(:first_purchaser) { Purchaser.first }
      let(:first_item) { Item.first }
      let(:first_merchant) { Merchant.first }

      subject { upload.import! }

      before do
        CSV.stub(:foreach).and_yield(file_contents)
      end

      context "with valid purchases" do
        it { should be_true }

        it "opens the CSV file" do
          expect(CSV).to receive(:foreach).with(upload.file.path, col_sep: "\t", return_headers: false, headers: true)
          subject
        end

        it "creates a purchase" do
          subject
          expect(first_purchase).not_to be_nil
          expect(first_purchase.upload).to eq upload
          expect(first_purchase.purchaser).to eq first_purchaser
          expect(first_purchase.item).to eq first_item
          expect(first_purchase.merchant).to eq first_merchant
          expect(first_purchase.purchase_count).to eq 2
        end

        it "creates a purchaser" do
          subject
          expect(first_purchaser).not_to be_nil
          expect(first_purchaser.name).to eq 'Snake Plissken'
        end

        it "creates an item" do
          subject
          expect(first_item).not_to be_nil
          expect(first_item.merchant).to eq first_merchant
          expect(first_item.description).to eq '$10 off $20 of food'
          expect(first_item.price).to eq 10
        end

        it "creates a merchant" do
          subject
          expect(first_merchant).not_to be_nil
          expect(first_merchant.name).to eq "Bob's Pizza"
          expect(first_merchant.address).to eq '987 Fake St'
        end
      end

      context "with invalid purchases" do
        let(:file_contents) {{
            'purchaser name' => '',
            'item description' => '',
            'item price' => 12.0,
            'purchase count' => 5,
            'merchant address' => '987 Fake St',
            'merchant name' => "Bob's Pizza"
        }}

        it { expect { should }.to raise_error }
      end

      context "with an exception" do
        before { CSV.stub(:foreach).and_raise }

        it { expect { should }.to raise_error }
      end
    end
  end
end
