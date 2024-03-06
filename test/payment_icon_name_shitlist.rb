# Dated: 9th Nov 2022
# Author: Rahil Virani
#
# The special characters in the name has caused a lot of issues in the past
# to seamlessly deploy the new icons. This is casued by
# repositories using different seperators for their local list of acceptable icons
# i.e. Jascript uses camelcase vs. others using underscore. The value of the name
# also reflects the name of the svg file and certain attributes in the svg, it is becoming
# harder to keep them in sync in multiple repositories.
#
# Decision: Moving forward we should only accept lower case alpha characters in the name
class PaymentIconNameShitlist
  class << self
    LIST_OF_EXEMPTED_NAMES = %w(
      american_express
      diners_club
      cartes_bancaires
      ing_homepay
      bitcoin_cash
      kbc_cbc
      sepa_bank_transfer
      google_pay
      google_wallet
      payfast_instant_eft
      airtel_money
      ola_money
      danske_bank
      klarna-pay-now
      klarna-pay-later
      klarna-slice-it
      przelew24
      collector_bank
      apple_pay
      shopify_pay
      paymark_online_eftpos
      esr_paymentslip_switzerland
      eft_secure
      in3
      v_pay
      maybankm2u
      publicbank_pbe
      bc_card
      hana_card
      hyundai_card
      kb_card
      lotte_card
      nh_card
      samsung_card
      shinhan_card
      kakao_pay
      naver_pay
      samsung_pay
      afterpay_paynl_version
      line_pay
      rakuten_pay
      pay_easy
      mtn_mobile_money
      airteltigo_mobile_money
      d_barai
      docomo_barai
      pay_pay
      au_kantan_kessai
      latitude_creditline_au
      latitude_gem_au
      latitude_gem_nz
      latitude_go_au
      bogus_app_coin
      postfinance_card
      postfinance_efinance
      alipay_hk
      qr_promptpay
      bri_direct_debit
      facebook_pay
      vvv_giftcard
      checkout_finance
      n26
      echelon_financing
      acima_leasing
      synchrony_pay
      truemoney_pay
      gmo-postpay
      gift-card
      pop-pankki
      s-pankki
      snap_checkout
      sveab2binvoice
      sveab2bfaktura
      billink_method
      sveaOstukonto
      sveaCreditAccount
    )
    def exempted
      LIST_OF_EXEMPTED_NAMES
    end
  end
end
