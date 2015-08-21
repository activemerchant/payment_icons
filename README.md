# PaymentIcons

PaymentIcons is a simple Ruby on Rails engine extracted from Shopify. Shopify supports multiple payment methods through gems like Active Merchant and Offsite Payments. This has lead to an accumulation of icons for various payment methods. This gem provides easy access to those icons and helpful methods to integrate them into any Ruby on Rails app.

## Usage

### From Git
You can check out the latest source from git:

    git clone https://github.com/activemerchant/payment_icons.git

### From RubyGems

Installation from RubyGems:
Run `gem install payment_icons` in your console.

If you'd like to add it to your existing Rails project, include `gem 'payment_icons'` in your Gemfile and run `bundle install`.

Once the gem is part of your Rails project, the PaymentIcon [frozen record](https://github.com/byroot/frozen_record) model will be available anywhere in your application. You also have access to all the [icons](https://github.com/activemerchant/payment_icons/tree/master/app/assets/images/payment_icons) with the path `app/assets/images/payment_icons/<icon_name.svg>`.
For example, you can do

    <% PaymentIcon.credit_cards.each do |card| %>
       <div><%= image_tag PaymentIcon.path(card.name) %>    </div>
    <% end %>
in your application views among other things.

## Contributing

If you'd like to add a new payment method icon to this repository,

1. [Fork it] (https://github.com/activemerchant/payment_icons/fork) and clone it.
2. Create a branch (`git checkout -b my_new_icon`)
3. Add `your-icon.svg` to the `app/assets/images/payment_icons/` directory. This file has to be 38 by 24 pixels.
4. Edit `db/payment_icons.yml` file with the id, name, label and group of your icon. We currently have credit_cards, cryptocurrencies, mobile_wallets, bank_transfers and other as possible group options.
5. Push your changes to your fork ('git push origin my_new_icon`)
6. Open a [pull request](https://github.com/activemerchant/payment_icons/pulls). One of our awesome maintainers will review it.
