require 'test_helper'

class IconsControllerTest < ActionController::TestCase

  test 'app can access payment_icons methods' do
    assert_equal ['visa', 'master', 'discover', 'american-express', 'diners-club', 'jcb'], PaymentIcon.credit_cards.pluck(:name)
  end
end
