require 'test_helper'

class PaymentIconTest < ActiveSupport::TestCase

  test '#all returns some records' do
    refute PaymentIcon.all.empty?
  end

  test '#credit_cards returns all icons of group credit card' do
    assert_equal ['visa', 'master', 'discover', 'american-express', 'diners-club', 'jcb'], PaymentIcon.credit_cards.pluck(:name)
  end

  test '#cryptocurrencies returns all icons of group cryptocurrencies' do
    assert_equal ['bitcoin', 'dogecoin', 'litecoin'], PaymentIcon.cryptocurrencies.pluck(:name)
  end

  test '#bank_transfers returns all icons of group bank_transfers' do
    assert_equal ['boleto', 'dankort', 'dwolla', 'forbrugsforeningen', 'giropay', 'laser', 'sofort', 'maestro', 'unionpay', 'visaelectron'], PaymentIcon.bank_transfers.pluck(:name)
  end

  test '#wallets returns all icons of group wallets' do
    assert_equal ['amazon', 'google-wallet', 'paypal'], PaymentIcon.wallets.pluck(:name)
  end

  test '#find_by_group returns all icons of group passed' do
    assert_equal ['boleto', 'dankort', 'dwolla', 'forbrugsforeningen', 'giropay', 'laser', 'sofort', 'maestro', 'unionpay', 'visaelectron'], PaymentIcon.find_by_group('bank_transfers').pluck(:name)
  end

  test '#path returns path within app/assets/images' do
    visa = PaymentIcon.where(name: 'visa').first
    assert_equal 'payment_icons/visa.svg', visa.path
  end

end
