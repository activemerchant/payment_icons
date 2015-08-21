require 'test_helper'

class PaymentIconTest < ActiveSupport::TestCase

  test "#find works" do
    icon = PaymentIcon.find(1)
    assert_equal "visa", icon.name
    assert_equal "Visa", icon.label
    assert_equal "credit_cards", icon.group
  end

  test "#all works" do
    refute PaymentIcon.all.empty?
  end

  test "#credit_cards returns all icons of group credit card" do
    assert_equal ["visa", "master", "discover", "american-express", "diners-club", "jcb"], PaymentIcon.credit_cards.pluck(:name)
  end

  test "#cryptocurrencies returns all icons of group cryptocurrency" do
    assert_equal ["bitcoin", "dogecoin", "litecoin"], PaymentIcon.cryptocurrencies.pluck(:name)
  end

  test "#find_by_group returns all icons of group passed" do
    assert_equal ["boleto", "dwolla", "giropay", "sofort", "unionpay"], PaymentIcon.find_by_group('bank_transfers').pluck(:name)
  end

  test "#path returns path within app/assets/images" do
    assert_equal "payment_icons/visa.svg", PaymentIcon.path('visa')
  end

end
