# This class provides actions to import purchases.
class PurchasesController < ApplicationController
  before_filter :authenticate_user!

  # @!group Exposures

  # @!attribute purchases
  # The purchases that were imported.
  # @return [Relation<Purchase>]
  expose(:purchases)

  # @!group Actions

  # This action imports the selected file.
  #
  # @request_param [Hash] import
  #  * +file+: The file being imported.
  #
  # @render index
  # @redirect index
  def import
    begin
      if File.extname(import_params[:file].original_filename) == '.tab'
        if Purchase.import(import_params[:file].tempfile)
          redirect_to({action: :index}, notice: 'The file was imported successfully')
        else
          flash[:alert] = 'There were errors in your file'
          render :index
        end
      else
        flash[:alert] = 'The file type is incorrect. Use a .tab file'
        render :index
      end
    rescue
      flash[:alert] = 'There was an error. Make sure you select a file'
      render :index
    end
  end

  # This action displays all the imported purchases.
  #
  # @render index
  # @return [Action]
  def index
  end

  private

  def import_params
    params.require(:import).permit(:file)
  end
end
