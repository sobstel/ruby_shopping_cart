# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/checkout'
require_relative '../lib/item'
require_relative '../lib/promotional_rules/multiple_item_rule'
require_relative '../lib/promotional_rules/total_price_rule'

describe Checkout do
  before do
    items = [
      Item.new('001', 'Red Scarf', 925),
      Item.new('002', 'Silver cufflinks', 4500),
      Item.new('003', 'Silk Dress', 1995)
    ]

    @indexed_items = Hash[items.map(&:product_code).zip(items)]

    @promotional_rules = [
      MultipleItemRule.new('001', 850),
      TotalPriceRule.new(6000, 0.9)
    ]
  end

  describe 'example cases' do
    # Basket: 001, 002, 003
    # Total price expected: 66.78
    it 'test case 1' do
      checkout = Checkout.new(@promotional_rules)
      checkout.scan(@indexed_items['001'])
      checkout.scan(@indexed_items['002'])
      checkout.scan(@indexed_items['003'])

      assert_equal 66.78, checkout.total
    end

    # Basket: 001, 003, 001
    # Total price expected: 36.95
    it 'test case 2' do
      checkout = Checkout.new(@promotional_rules)
      checkout.scan(@indexed_items['001'])
      checkout.scan(@indexed_items['003'])
      checkout.scan(@indexed_items['001'])

      assert_equal 36.95, checkout.total
    end

    # Basket: 001, 002, 001, 003
    # Total price expected: 73.76
    it 'test case 3' do
      checkout = Checkout.new(@promotional_rules)
      checkout.scan(@indexed_items['001'])
      checkout.scan(@indexed_items['002'])
      checkout.scan(@indexed_items['001'])
      checkout.scan(@indexed_items['003'])

      assert_equal 73.76, checkout.total
    end
  end

  it 'order of items does not affect a price' do
    checkout1 = Checkout.new(@promotional_rules)
    checkout1.scan(@indexed_items['001'])
    checkout1.scan(@indexed_items['002'])
    checkout1.scan(@indexed_items['001'])
    checkout1.scan(@indexed_items['003'])

    checkout2 = Checkout.new(@promotional_rules)
    checkout2.scan(@indexed_items['003'])
    checkout2.scan(@indexed_items['002'])
    checkout2.scan(@indexed_items['001'])
    checkout2.scan(@indexed_items['001'])

    checkout3 = Checkout.new(@promotional_rules)
    checkout3.scan(@indexed_items['001'])
    checkout3.scan(@indexed_items['003'])
    checkout3.scan(@indexed_items['002'])
    checkout3.scan(@indexed_items['001'])

    assert_equal checkout1.total, checkout2.total
    assert_equal checkout2.total, checkout3.total
  end

  it 'multiple runs return same value' do
    checkout = Checkout.new(@promotional_rules)
    checkout.scan(@indexed_items['001'])
    checkout.scan(@indexed_items['002'])
    checkout.scan(@indexed_items['003'])
    checkout.scan(@indexed_items['001'])

    assert_equal 73.76, checkout.total
    assert_equal 73.76, checkout.total
    assert_equal 73.76, checkout.total
  end

  it 'no items return zero price' do
    checkout = Checkout.new(@promotional_rules)
    assert_equal 0, checkout.total
  end

  it 'empty ruleset does not apply any discounts' do
    checkout = Checkout.new([])
    checkout.scan(@indexed_items['001'])
    checkout.scan(@indexed_items['002'])
    checkout.scan(@indexed_items['003'])
    checkout.scan(@indexed_items['001'])

    assert_equal 83.45, checkout.total
  end
end
