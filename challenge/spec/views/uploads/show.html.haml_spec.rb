describe "uploads/show.html.haml" do
  let(:user) { create(:user) }
  let(:upload) { create(:upload) }
  let!(:purchase_1) { create(:purchase) }
  let!(:purchase_2) { create(:purchase) }

  before do
    view.stub current_user: user
    view.stub upload: upload
    view.stub purchases: Purchase.all
    render
  end

  subject { rendered }

  it { should have_selector 'h1', content: upload.file_file_name }
  it { should have_selector 'a', href: new_upload_path, content: 'Import another file' }
  it { should include purchase_1.purchaser.name }
  it { should include purchase_1.merchant.name }
  it { should include purchase_1.merchant.address }
  it { should include purchase_1.item.description }
  it { should include purchase_1.purchase_count.to_s }
  it { should include number_to_currency(purchase_1.item.price) }
  it { should include number_to_currency(Purchase.all.subtotal) }
  it { should include number_to_currency(Purchase.all.gross) }
end
