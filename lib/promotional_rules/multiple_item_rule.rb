# frozen_string_literal: true

##
# Promotional rule (multiple occurences of specified item)
#
# When purchasing 2 or more items having specified product code,
# its price is set to new value (`new_price_in_cents`).
#
class MultipleItemRule
  MULTIPLE_THRESHOLD = 2

  ##
  # @param product_code [String] Product code, eg "001"
  # @param new_price_in_cents [Integer] New price to set
  #
  def initialize(product_code, new_price_in_cents)
    @product_code = product_code
    @new_price_in_cents = new_price_in_cents
  end

  ##
  # @param items [Array<Item>]
  # @return [Array<Item>]
  #
  def apply(items)
    return items if item_count(items) < MULTIPLE_THRESHOLD

    items.each do |item|
      item.price_in_cents = @new_price_in_cents if item_satisfy?(item)
    end
  end

  private

  ##
  # Counts number of occurrences having a product code required by the rule
  #
  # @param items [Array<Item>]
  # @return [Integer]
  #

  def item_count(items)
    items.count { |item| item_satisfy?(item) }
  end

  ##
  # Checs if a give item has a required product code
  #
  # @param items [Item]
  # @param [Boolean]

  def item_satisfy?(item)
    item.product_code == @product_code
  end
end
