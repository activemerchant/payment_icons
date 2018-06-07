# Payment Icons

Payment Icons is a simple Ruby on Rails engine extracted from Shopify. Shopify supports multiple payment methods through gems like Active Merchant and Offsite Payments. This has lead to an accumulation of icons for various payment methods. This gem provides easy access to those icons and helpful methods to integrate them into any Ruby on Rails app.

## Usage

### From Git
You can check out the latest source from git:

```sh
git clone https://github.com/activemerchant/payment_icons.git
```

### From RubyGems

Run `gem install payment_icons` in your console.

If you'd like to add it to your existing Rails project, include `gem 'payment_icons'` in your Gemfile and run `bundle install`.

Once the gem is part of your Rails project, the PaymentIcon [frozen record](https://github.com/byroot/frozen_record) model will be available anywhere in your application. You also have access to all the [icons](https://github.com/activemerchant/payment_icons/tree/master/app/assets/images/payment_icons) with the path `app/assets/images/payment_icons/<icon_name.svg>`.

For example:

```erb
<% PaymentIcon.credit_cards.each do |card| %>
  <div>
    <%= image_tag card.path %>
  </div>
<% end %>
```

## Contributing
To add a new payment method icon to this repository:

1. [Fork the repository](https://github.com/activemerchant/payment_icons/fork) and clone it
2. Create a branch (`git checkout -b my_new_icon`)
3. Add `your-icon.svg` to the `app/assets/images/payment_icons/` directory with the following specifications:

    - 38 by 24 pixels
    - Solid white background
    - 1 pixel wide solid grey border
    - `role="img"` attribute on the root `<svg>` tag
    - `aria-labelledby` attribute on the root `<svg>` tag, equal to `pi-` + the name of your icon
    - `<title>` tag containing the label of your icon, with an `id` attribute equal to `pi-` + the name of your icon

    Here's a template to get started (don't forget to replace `your-icon`):

    ```
    <svg xmlns="http://www.w3.org/2000/svg" role="img" width="38" height="24" aria-labelledby="pi-your-icon">
      <title id="pi-your-icon">Your Icon</title>
      <path opacity=".07" d="M35 0H3C1.3 0 0 1.3 0 3v18c0 1.7 1.4 3 3 3h32c1.7 0 3-1.3 3-3V3c0-1.7-1.4-3-3-3z"/>
      <path fill="#fff" d="M35 1c1.1 0 2 .9 2 2v18c0 1.1-.9 2-2 2H3c-1.1 0-2-.9-2-2V3c0-1.1.9-2 2-2h32"/>
    </svg>
    ```

4. Edit `db/payment_icons.yml` file with the name, label and group of your icon. Valid group options are as follows:

    - `bank_transfers`
    - `convenience_stores`
    - `credit_cards`
    - `cryptocurrencies`
    - `other`
    - `wallets`

5. Optimize your icon

    ```
    $ npm install -g svgo
    $ svgo /path/to/your-icon.svg --disable={removeUnknownsAndDefaults,removeTitle,cleanupIDs,removeViewBox}
    ```

5. Push your changes to your fork (`git push origin my_new_icon`)
6. Open a [pull request](https://github.com/activemerchant/payment_icons/pulls) and one of our maintainers will review it.

*The trademarks and trade names provided in this library are those of their respective owners.*
