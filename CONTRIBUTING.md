# Contributing

To add a new payment method icon to this repository:

1. [Fork the repository](https://github.com/activemerchant/payment_icons/fork) and clone it
2. Create a branch (`git checkout -b my_new_icon`)
3. Edit `db/payment_icons.yml` file with the `name`, `label` and `group` of your icon. Valid group options are as follows:

    - `bank_transfers`
    - `convenience_stores`
    - `credit_cards`
    - `cryptocurrencies`
    - `other`
    - `wallets`

4. Add an SVG icon to the `app/assets/images/payment_icons/` directory following the [guidelines for new icons](#guidelines-for-new-icons).
5. Optimize your icon using [SVGO](https://jakearchibald.github.io/svgomg/) - instructions below.

    ```
    $ npm install -g svgo
    $ svgo your-icon.svg --disable={removeUnknownsAndDefaults,removeTitle,cleanupIDs,removeViewBox}
    ```

5. Push your changes to your fork (`git push origin my_new_icon`)
6. Open a [pull request](https://github.com/activemerchant/payment_icons/pulls) and one of our maintainers will review it.

*The trademarks and trade names provided in this library are those of their respective owners.*

## Guidelines for new icons

The markup below will also make the icon accessible to assistive technology when used as an inline SVG. Icons are to follow a set of guidelines to provide consistency in appearance.

### File
- The name of the SVG must be the same as the `name` entered in `db/payment_icons.yml`

### Markup
- The root `<svg>` tag has the following attributes:
  - `viewBox="0 0 38 24"`
  - `width="38"` and `height="24"`
  - `role="img"`
  - `aria-labelledby` with the value `pi-` + the name of your icon
- The root `<svg>` tag has a nested `<title>` tag with the following:
  - `id` attribute with the value `pi-` + the name of your icon, (same as the `aria-labelledby`)
  - Inner text containing the label of your icon
- The `<svg>` must use vector graphics, i.e. `path`, `rect`, etc.
  - Nested `<image>` or `<img>` elements will not be accepted.
  - Embedded fonts or bitmaps will not be accepted.

### Appearance
- Logos appear on a solid color background
  - Whenever possible, the background color should be white.
- A 1 pixel wide solid grey border with 0.07% opacity surrounds the svg.
  - This gives the icons a consistent shape on websites whose backgrounds match that of the icon.

### Template

The HTML below has the required markup detailed above. Don't forget to replace `{your-icon}` with the appropriate text of your payment method/brand.

```html
<svg xmlns="http://www.w3.org/2000/svg" role="img" viewBox="0 0 38 24" width="38" height="24" aria-labelledby="pi-{your-icon}">
    <title id="pi-{your-icon}">{Your icon}</title>
    <path opacity=".07" d="M35 0H3C1.3 0 0 1.3 0 3v18c0 1.7 1.4 3 3 3h32c1.7 0 3-1.3 3-3V3c0-1.7-1.4-3-3-3z"/>
    <path fill="#fff" d="M35 1c1.1 0 2 .9 2 2v18c0 1.1-.9 2-2 2H3c-1.1 0-2-.9-2-2V3c0-1.1.9-2 2-2h32"/>
</svg>
```
