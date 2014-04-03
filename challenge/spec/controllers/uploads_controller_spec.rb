describe UploadsController do
  let(:params) { ActionController::Parameters.new }
  let(:user) { create(:user) }

  before do
    controller.stub :authenticate_user!
    controller.stub current_user: user
  end

  describe "exposures" do
    describe "uploads" do
      let!(:upload_1) { create(:upload) }
      let!(:upload_2) { create(:upload) }
      let!(:upload_3) { create(:upload) }
      subject { controller.uploads }

      it { should be_an ActiveRecord::Relation }
      it { should include upload_1 }
      it { should include upload_2 }
      it { should include upload_3 }
    end

    describe "upload" do
      let!(:upload) { create(:upload) }
      subject { controller.upload }

      before { controller.params[:id] = upload.id }

      it { should eq upload }
    end

    describe "purchases" do
      let!(:upload) { create(:upload) }
      let!(:purchase_1) { create(:purchase, upload: upload) }
      let!(:purchase_2) { create(:purchase) }
      subject { controller.purchases }

      before { controller.stub upload: upload }

      it { should be_an ActiveRecord::Relation }
      it { should include purchase_1 }
      it { should_not include purchase_2 }
    end
  end

  describe "actions" do
    describe "show" do
      let(:upload) { create(:upload) }
      subject { response }

      before do
        params[:id] = upload.id
        get :show, params
      end

      it { should be_success }
      it { should render_template :show }
    end

    describe "new" do
      subject { response }

      before do
        get :new
      end
      
      it { should be_success }
      it { should render_template :new }
    end

    describe "create" do
      let(:upload) { create(:upload) }
      subject { response }

      before do
        controller.stub upload: upload
        upload.stub save!: true, import!: true
      end

      shared_examples_for "invalid_submission" do
        it { expect(flash[:alert]).not_to be_blank }
        it { should render_template :new }
      end

      context "with a successful submission" do
        before do
          controller.stub upload_params: { file: fixture_file_upload('test.tab', 'application/octet-stream') }
          post :create, params
        end

        it { expect(flash[:notice]).not_to be_blank }
        it { should redirect_to upload_path(controller.upload) }
      end

      context "with an invalid file" do
        before do
          upload.stub(:save!).and_raise
          post :create, params
        end

        it_behaves_like "invalid_submission"
      end

      context "with errors creating purchases" do
        before do
          upload.stub(:import!).and_raise
          post :create, params
        end

        it_behaves_like "invalid_submission"
      end
    end
  end
end
