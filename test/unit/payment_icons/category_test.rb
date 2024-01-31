# frozen_string_literal: true

require 'test_helper'

module PaymentIcons
  class CategoryTest < ActiveSupport::TestCase
    test "All categories are returned" do
      assert_equal(7, Category.count)
    end

    test "Every category record is valid" do
      Category.all.each do |category|
        assert_predicate(category.name, :present?)
      end
    end
  end
end
