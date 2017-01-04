require 'test_helper'

class IconsControllerTest < ActionController::TestCase

  test 'can find all payment icon assets' do
    PaymentIcon.all.each do |icon|
      assert_not_nil Rails.application.assets.find_asset("payment_icons/#{icon.name}.svg"), "#{icon.name} not found"
    end
  end

  test 'show page has digested image tags for all credit card icons' do
    get :show
    PaymentIcon.credit_cards.each do |card|
      assert_select "##{card.name}" do |element|
        assert_select "[src=?]", "/assets/#{Rails.application.assets.find_asset("payment_icons/#{card.name}.svg").digest_path}"
      end
    end
  end

  test 'show page has digested image tags for all cryptocurrency icons' do
    get :show
    PaymentIcon.cryptocurrencies.each do |currency|
      assert_select "##{currency.name}" do |element|
        assert_select "[src=?]", "/assets/#{Rails.application.assets.find_asset("payment_icons/#{currency.name}.svg").digest_path}"
      end
    end
  end

end
