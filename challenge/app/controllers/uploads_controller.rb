# This class provides actions to import purchases.
class UploadsController < ApplicationController
  before_filter :authenticate_user!

  # @!group Exposures

  # @!attribute uploads
  # The uploads that were created.
  # @return [Relation<Upload>]
  expose(:uploads) { Upload.order('created_at desc') }

  # @!attribute upload
  # The current upload.
  # @return [Upload]
  expose(:upload)

  # @!attribute purchases
  # The purchases created by the upload.
  # @return [Relation<Purchase>]
  expose(:purchases) { upload.purchases }

  # @!group Actions

  # This action displays the upload.
  #
  # @request_param [String] id
  #  The uploads ID.
  #
  # @render show
  # @return [Action]
  def show
  end

  # This action displays a form to upload a file.
  #
  # @render new
  # @return [Action]
  def new
  end

  # This action uploads a file.
  #
  # @request_param [Hash] upload
  #  * +file+: The file being uploaded.
  #
  # @render new
  # @redirect show
  def create
    begin
      upload.attributes = upload_params
      upload.creator = current_user

      Upload.transaction do
        if upload.save! && upload.import!
          redirect_to upload_path(upload), notice: 'The file was imported successfully'
        end
      end
    rescue => e
      flash[:alert] = e.message
      render :new
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:file)
  end
end
