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
    PaymentIcon.all.each do |icon|
      assert_equal "payment_icons/#{icon.name}.svg", icon.path
    end
  end

  test 'Every payment icon record has a corresponding SVG file' do
    ICONS_DIRECTORY = Rails.root.join("..", "..", "app/assets/images/payment_icons")

    PaymentIcon.all.each do |icon|
      assert File.exist?(ICONS_DIRECTORY.join("#{icon.name}.svg"))
    end
  end
end
