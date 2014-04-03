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

      it "is a relation" do
        expect(subject).to be_an ActiveRecord::Relation
      end

      it "includes all uploads" do
        expect(subject).to include upload_1
        expect(subject).to include upload_2
        expect(subject).to include upload_3
      end

      it "sorts the uploads by creation time desc" do
        expect(subject.index(upload_3)).to be < subject.index(upload_2)
        expect(subject.index(upload_2)).to be < subject.index(upload_1)
      end
    end

    describe "upload" do
      let!(:upload) { create(:upload) }
      subject { controller.upload }

      before { controller.params[:id] = upload.id }

      it "is the upload" do
        expect(subject).to eq upload
      end
    end

    describe "purchases" do
      let!(:upload) { create(:upload) }
      let!(:purchase_1) { create(:purchase, upload: upload) }
      let!(:purchase_2) { create(:purchase) }
      subject { controller.purchases }

      before { controller.stub upload: upload }

      it "is a relation" do
        expect(subject).to be_an ActiveRecord::Relation
      end

      it "includes upload's purchases" do
        expect(subject).to include purchase_1
      end

      it "does not include other purchases" do
        expect(subject).not_to include purchase_2
      end
    end
  end

  describe "actions" do
    describe "show" do
      let(:upload) { create(:upload) }

      before do
        params[:id] = upload.id
        get :show, params
      end
      
      it "is a success" do
        expect(response).to be_success
      end
      
      it "renders the show page" do
        expect(response).to render_template :show
      end
    end

    describe "new" do
      before do
        get :new
      end
      
      it "is a success" do
        expect(response).to be_success
      end
      
      it "renders the new page" do
        expect(response).to render_template :new
      end
    end

    describe "create" do
      let(:upload) { create(:upload) }

      before do
        controller.stub upload: upload
        upload.stub save!: true, import!: true
      end

      shared_examples_for "invalid_submission" do
        it "sets an alert notice" do
          expect(flash[:alert]).not_to be_blank
        end

        it "renders the new page" do
          expect(response).to render_template :new
        end
      end

      context "with a successful submission" do
        before do
          controller.stub upload_params: { file: fixture_file_upload('test.tab', 'application/octet-stream') }
          post :create, params
        end

        it "sets a notice message" do
          expect(flash[:notice]).not_to be_blank
        end

        it "redirects to the created upload" do
          expect(response).to redirect_to upload_path(controller.upload)
        end
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
