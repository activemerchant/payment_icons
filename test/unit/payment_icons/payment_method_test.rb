# frozen_string_literal: true

require "test_helper"

module PaymentIcons
  class PaymentMethodTest < ActiveSupport::TestCase

    def setup
      @fake_payment_methods = [
        PaymentMethod.new(
          name: "PM1",
          label: "Payment Method 1",
          categories: ["credit_card"]
        ),
        PaymentMethod.new(
          name: "PM2",
          label: "Payment Method 2",
          categories: ["credit_card", "wallet"]
        ),
        PaymentMethod.new(
          name: "PM3",
          label: "Payment Method 3",
          categories: ["cryptocurrency"]
        ),
      ]
    end

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

    test "#find_by_category returns all payment methods with that category name" do
      PaymentMethod.stubs(:all).returns(@fake_payment_methods)

      assert_equal(2, PaymentMethod.find_by_category("credit_card").count)
      assert_equal(1, PaymentMethod.find_by_category("cryptocurrency").count)
      assert_equal(0, PaymentMethod.find_by_category("dummy").count)
    end

    test "#find_by_category excludes payment methods with excluded catagory name" do
      PaymentMethod.stubs(:all).returns(@fake_payment_methods)

      assert_equal(1, PaymentMethod.find_by_category("credit_card", exclude: ["wallet"]).count)
    end

    test "#all_except_categories excludes payment methods with excluded catagory name" do
      PaymentMethod.stubs(:all).returns(@fake_payment_methods)

      assert_equal(2, PaymentMethod.all_except_categories(["wallet"]).count)
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
