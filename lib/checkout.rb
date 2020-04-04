# frozen_string_literal: true

##
# Checkout is responsible for storing basket items and calculating total price
# (using promotional rules).
#
class Checkout
  ##
  # @param promotional_rules [Array]
  #
  def initialize(promotional_rules)
    @items = []
    @promotional_rules = promotional_rules
  end

  ##
  # Adds new item for checkout
  #
  # @param item [Item]
  #
  def scan(item)
    @items << item
  end

  ##
  # Returns total price
  #
  # @return [Float]
  #
  def total
    with_promotional_rules do |items|
      items.sum(&:price).round(2)
    end
  end

  private

  ##
  # Applies promotional rules to previously added items
  #
  # @example
  #
  #   with_promotional_rules { |items| ... }
  #
  #
  def with_promotional_rules
    items_dup = @items.dup.map(&:dup)
    discounted_items = @promotional_rules.reduce(items_dup) do |items, rule|
      rule.apply(items)
    end

    yield(discounted_items)
  end
end
