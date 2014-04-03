describe "purchases/_select_file.html.haml" do
  let(:user) { create(:user) }

  before do
    view.stub current_user: user
    render
  end

  it "has a form to import files" do
    expect(rendered).to have_selector 'form', action: import_purchases_path
  end

  it "has a file field" do
    expect(rendered).to have_selector 'input', type: 'file', name: 'import[file]'
  end

  it "has a submit button" do
    expect(rendered).to have_selector 'input', type: 'submit'
  end
end
