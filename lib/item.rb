# frozen_string_literal: true

##
# Item is a product in the basket (added for checkout)
#
Item = Struct.new(:product_code, :name, :price_in_cents) do
  def price
    price_in_cents / 100.0
  end
end
