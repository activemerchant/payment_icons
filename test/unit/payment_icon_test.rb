require 'test_helper'

class PaymentIconTest < ActiveSupport::TestCase

  test "Every payment icon record is valid" do
    PaymentIcon.all.each do |icon|
      assert_predicate icon.name, :present?
      assert_predicate icon.label, :present?
      assert_includes PaymentIcon::GROUPS.keys, icon.group.to_sym
    end
  end

  test '#path returns path within app/assets/images' do
    visa = PaymentIcon.where(name: 'visa').first
    assert_equal 'payment_icons/visa.svg', visa.path
  end
end
