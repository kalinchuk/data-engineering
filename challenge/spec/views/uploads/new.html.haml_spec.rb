describe "uploads/new.html.haml" do
  let!(:user) { create(:user) }
  let!(:upload) { create(:upload) }

  before do
    view.stub current_user: user
    view.stub upload: Upload.new
    view.stub uploads: Upload.all
    render
  end

  subject { rendered }

  it { should have_selector 'form', action: uploads_path }
  it { should have_selector 'input', type: 'file', name: 'upload[file]' }
  it { should have_selector 'input', type: 'submit' }
  it { should include upload.creator.email }
  it { should have_selector 'a', href: upload_path(upload), content: upload.file_file_name }
end
