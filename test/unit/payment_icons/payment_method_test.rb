# frozen_string_literal: true

require "test_helper"

module PaymentIcons
  class PaymentMethodTest < ActiveSupport::TestCase
    test "Every records are valid" do
      PaymentMethod.all.each do |payment_method|
        assert_predicate(payment_method.name, :present?)
        assert_predicate(payment_method.label, :present?)
        assert_not_nil(payment_method.categories)
      end
    end

    test "Records are loaded correctly" do
      assert_predicate(PaymentMethod.all, :any?)
    end

    test "Every payment methods have a default icon" do
      PaymentMethod.all.each do |payment_method|
        File.read("#{Engine::IMAGES_DIRECTORY}/#{payment_method.default_icon_path}")
      end
    end

    test "#find_by_category_name returns all payment methods with that category name" do
      assert_equal(42, PaymentMethod.find_by_category_name("credit_card").count)
      assert_equal(79, PaymentMethod.find_by_category_name("wallet").count)
      assert_equal(31, PaymentMethod.find_by_category_name("cryptocurrency").count)
      assert_equal(0, PaymentMethod.find_by_category_name("dummy").count)
    end

    test "#icon_variation_path raises when the variation doesn't exist" do
      variation_name = "SuperDuper"
      payment_method = PaymentMethod.first

      assert_raise(PaymentMethod::UnknownIconVariationError) do
        payment_method.icon_variation_path(variation_name)
      end
    end
  end
end
