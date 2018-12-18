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

For information on adding or updating payment icons, see our [CONTRIBUTING.md](https://github.com/activemerchant/payment_icons/blob/master/CONTRIBUTING.md) file.

### Releases

This information is for project maintainers: 

Any updates that add new icons, or change the style of existing ones, are to be considered patches (i.e. `v1.0.X`).

To create a new release:
- Change version in `lib/<gem name>/version.rb`
- Run `bundle install`
- Commit the changes
- `git tag -a v<version>`
- If prompted, make a comment about this version bump. i.e. "Adds icons X and Y"
- `git push --tags origin master`
- Contact a maintainer in Shopify to release the new version via ShipIt.

Once dployed via ShipIt, you will see a new release at https://rubygems.org/gems/payment_icons
