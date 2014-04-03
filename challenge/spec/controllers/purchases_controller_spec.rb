describe PurchasesController do
  let(:params) { ActionController::Parameters.new }

  before do
    controller.stub :authenticate_user!
  end

  describe "exposures" do
    describe "purchases" do
      let!(:purchase_1) { create(:purchase) }
      let!(:purchase_2) { create(:purchase) }
      subject { controller.purchases }

      it "is a relation" do
        expect(subject).to be_an ActiveRecord::Relation
      end

      it "includes all purchases" do
        expect(subject).to include purchase_1
        expect(subject).to include purchase_2
      end
    end
  end

  describe "actions" do
    describe "import" do
      shared_examples_for "invalid_submission" do
        it "sets an alert notice" do
          expect(flash[:alert]).not_to be_blank
        end

        it "renders the index page" do
          expect(response).to render_template :index
        end
      end

      let(:file) { double(tempfile: 'path/to/file.tab', original_filename: 'file.tab') }

      before { Purchase.stub :import }

      context "with a file" do
        before do
          controller.stub import_params: { file: file }
        end

        context "with a valid submission" do
          before do
            Purchase.stub import: true
            post :import, params
          end

          it "attempts to import the purchases" do
            expect(Purchase).to have_received(:import)
          end

          it "sets a notice message" do
            expect(flash[:notice]).not_to be_blank
          end

          it "redirects to the index page" do
            expect(response).to redirect_to(action: :index)
          end
        end

        context "with errors" do
          before do
            Purchase.stub import: false
            post :import, params
          end

          it "attempts to import the purchases" do
            expect(Purchase).to have_received(:import)
          end

          it_behaves_like "invalid_submission"
        end

        context "with an incorrect file type" do
          before do
            file.stub original_filename: 'file.incorrect'
            post :import, params
          end

          it_behaves_like "invalid_submission"
        end
      end

      context "without a file" do
        before do
          post :import, params
        end

        it_behaves_like "invalid_submission"
      end

      context "with an exception" do
        before do
          File.stub(:extname).and_raise
          post :import, params
        end

        it_behaves_like "invalid_submission"
      end
    end

    describe "index" do
      before do
        get :index
      end
      
      it "is a success" do
        expect(response).to be_success
      end
      
      it "renders the index page" do
        expect(response).to render_template :index
      end
    end
  end
end
