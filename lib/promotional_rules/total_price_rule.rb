# frozen_string_literal: true

##
# Promotional rule (total price)
#
# When spending over X (threshold_in_cents), the customer gets Y%
# (price_modifier) off their purchase
#
class TotalPriceRule
  ##
  # @param threshold_in_cents [Integer] Threshold over which discount is applied
  # @param price_modifier [Float] Multiplier, eg. 0.9 (which means 10% discount)
  #
  def initialize(threshold_in_cents, price_modifier)
    @threshold_in_cents = threshold_in_cents
    @price_modifier = price_modifier
  end

  ##
  # @param items [Array<Item>]
  # @return [Array<Item>]
  #
  def apply(items)
    return items if items.sum(&:price_in_cents) <= @threshold_in_cents

    items.each do |item|
      item.price_in_cents *= @price_modifier
    end
  end
end
