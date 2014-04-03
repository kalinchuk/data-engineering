describe "uploads/new.html.haml" do
  let!(:user) { create(:user) }
  let!(:upload) { create(:upload) }

  before do
    view.stub current_user: user
    view.stub upload: Upload.new
    view.stub uploads: Upload.all
    render
  end

  it "has a form to import files" do
    expect(rendered).to have_selector 'form', action: uploads_path
  end

  it "has a file field" do
    expect(rendered).to have_selector 'input', type: 'file', name: 'upload[file]'
  end

  it "has a submit button" do
    expect(rendered).to have_selector 'input', type: 'submit'
  end

  it "has the upload's creator" do
    expect(rendered).to include upload.creator.email
  end

  it "has the upload's file name" do
    expect(rendered).to have_selector 'a', href: upload_path(upload), content: upload.file_file_name
  end
end
