require 'test_helper'

class IconsControllerTest < ActionController::TestCase

  test "app can access payment_icons" do
    assert_equal ["visa", "master", "discover", "american-express", "diners-club", "jcb"], PaymentIcon.credit_cards.pluck(:name)
  end

  test "directory payment_icons was added to assets" do
    assert Dir.exists?('app/assets/images/payment_icons/')
  end

  test "app has payment_icons files in assets" do
    assert File.exists?('app/assets/images/payment_icons/visa.svg')
  end
end
