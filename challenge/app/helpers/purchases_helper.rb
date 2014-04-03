module PurchasesHelper
  # This method gets the subtotal for the purchases specified.
  #
  # @param [Relation] purchases
  #  The purchases to sum.
  #
  # @return [Float]
  def subtotal(purchases)
    purchases.includes(:item).sum('items.price')
  end

  # This method gets the gross total for the purchases specified.
  #
  # @param [Relation] purchases
  #  The purchases to get the gross total for.
  #
  # @return [Float]
  def gross(purchases)
    purchases.includes(:item).sum('items.price') * purchases.sum(:purchase_count)
  end
end