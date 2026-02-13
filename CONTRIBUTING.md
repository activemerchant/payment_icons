# Contributing

To add a new payment method icon to this repository:

## Quick Start

1. [Fork the repository](https://github.com/activemerchant/payment_icons/fork) and clone it
2. Create a branch (`git checkout -b my_new_icon`)
3. Add your icon following the [guidelines below](#guidelines-for-new-icons)
4. [Test locally](#test-locally) before submitting
5. Push your changes to your fork (`git push origin my_new_icon`)
6. Open a [pull request](https://github.com/activemerchant/payment_icons/pulls)

## What Happens After You Submit

When you open a pull request:

- ✅ **Automated Tests Run** - All 20 validation tests check your icon
- ✅ **Instant Feedback** - You'll receive an automated comment (@mentioning you) if issues are found
- ✅ **Selective Enforcement** - You won't be blocked by pre-existing violations in other icons
- ✅ **Clear Guidance** - The PR comment shows exactly what needs fixing

Tests complete in <1 second. Warnings about pre-existing violations in other icons won't block your PR.

---

## Step-by-Step Guide

### 1. Add Icon Metadata

Edit `db/payment_icons.yml` with the `name`, `label`, and `group` of your icon.

**Valid groups:**
- `bank_transfers`
- `convenience_stores`
- `credit_cards`
- `cryptocurrencies`
- `other`
- `wallets`

**Example:**
```yaml
- name: newpay
  label: NewPay
  group: wallets
```

### 2. Create SVG File

Add an SVG icon to `app/assets/images/payment_icons/` directory following the [guidelines below](#guidelines-for-new-icons).

**Using a generic icon?** Consider these existing options:
- [`cash`](https://github.com/activemerchant/payment_icons/blob/master/app/assets/images/payment_icons/cash.svg)
- [`generic`](https://github.com/activemerchant/payment_icons/blob/master/app/assets/images/payment_icons/generic.svg)
- [`gift-card`](https://github.com/activemerchant/payment_icons/blob/master/app/assets/images/payment_icons/gift-card.svg)
- [`onlinebanking`](https://github.com/activemerchant/payment_icons/blob/master/app/assets/images/payment_icons/onlinebanking.svg)
- [`storecredit`](https://github.com/activemerchant/payment_icons/blob/master/app/assets/images/payment_icons/storecredit.svg)
- [`wallet`](https://github.com/activemerchant/payment_icons/blob/master/app/assets/images/payment_icons/wallet.svg)

### 3. Optimize Your Icon

Use [SVGO](https://github.com/svg/svgo) to optimize file size:

```bash
# Install SVGO v1.x (recommended)
npm install -g svgo@1.3.2

# Optimize your icon
svgo your-icon.svg --disable={removeUnknownsAndDefaults,removeTitle,cleanupIDs,removeViewBox}
```

### 4. Test Locally

Run the same tests that CI will run:

```bash
# For a NEW icon
CHANGED_ICONS="youricon" NEW_ICONS="youricon" bundle exec rails test

# For MODIFYING an existing icon
CHANGED_ICONS="existingicon" bundle exec rails test

# Run all tests (optional)
bundle exec rails test
```

You'll see warnings for pre-existing violations in the library, but these won't fail your tests.

### 5. Submit Pull Request

Push your changes and open a pull request. Our maintainers will review it!

---

## Guidelines for New Icons

All icons must follow these guidelines. The **markup** and **requirements** are enforced by [20 automated tests](https://github.com/activemerchant/payment_icons/blob/master/test/unit/payment_icon_test.rb). The **appearance** guidelines aim to provide consistency in the icons' appearance. Duplicate icons will not be accepted.

### Understanding Test Enforcement

- **16 tests use standard enforcement** - All icons must pass (e.g., XML validation, dimensions, accessibility)
- **4 tests use selective enforcement** - New/modified icons held to higher standards, existing violations grandfathered

---

## Requirements

### ✅ Name Requirements in `db/payment_icons.yml`

**For NEW icons:**
- Must start with a lowercase letter
- Can contain lowercase letters and numbers only
- Any letter following a number MUST be uppercase
- NO underscores, hyphens, or special characters allowed

**Valid names:** `visa`, `mastercard`, `applePay`, `visa2Card`
**Invalid names:** `apple_pay`, `visa-card`, `visa1card`, `VisaCard`

**For MODIFIED icons:**
Existing icons with underscores (e.g., `apple_pay`) are grandfathered to avoid breaking existing integrations. You don't need to rename when updating the design.

---

### ✅ File Requirements

- **Filename:** Must match the `name` in `db/payment_icons.yml` exactly
- **Location:** `app/assets/images/payment_icons/your-icon.svg`
- **Format:** Single-line SVG (no line breaks except optional trailing newline)

---

### ✅ File Size Requirements

- **Hard limit:** 15KB maximum (enforced for new icons)
- **Soft limit:** 10KB recommended for optimal performance

Icons over 10KB will receive optimization suggestions. Run SVGO to optimize:

```bash
svgo your-icon.svg --disable={removeUnknownsAndDefaults,removeTitle,cleanupIDs,removeViewBox}
```

---

### ✅ SVG Markup Requirements

#### Root `<svg>` Tag Attributes

**Required attributes:**
```html
<svg xmlns="http://www.w3.org/2000/svg"
     role="img"
     viewBox="0 0 38 24"
     width="38"
     height="24"
     aria-labelledby="pi-youricon">
```

- `xmlns` - XML namespace (required)
- `viewBox` - Must be exactly `"0 0 38 24"`
- `width` - Must be `"38"`
- `height` - Must be `"24"`
- `role` - Must be `"img"` for accessibility
- `aria-labelledby` - Must be `"pi-"` + your icon name

#### Title Tag (Required)

The `<title>` tag must be the first child of `<svg>`:

```html
<title id="pi-youricon">Your Icon Label</title>
```

- `id` - Must match the `aria-labelledby` value
- Inner text - Use the label from `db/payment_icons.yml`

#### Content Guidelines

✅ **Allowed:**
- Vector graphics: `<path>`, `<rect>`, `<circle>`, `<polygon>`, etc.
- Inline styles (e.g., `fill="#000"`, `opacity=".07"`)
- Base64-encoded PNG data in `<image>` tags (if necessary)

❌ **Not Allowed:**
- `<style>` tags (use inline styles instead)
- `class` attributes (prevents external CSS dependencies)
- External image file paths
- Embedded fonts (`<font>`, `<font-face>`) or bitmaps
- Raster images via `<img>` or `<foreignObject>` (unless base64-encoded PNG)
- External stylesheets (`<?xml-stylesheet>`)

#### ID Attributes

All `id` attributes must start with `pi-` prefix:

```html
<path id="pi-youricon-background" .../>
<circle id="pi-youricon-logo" .../>
```

---

### ✅ Appearance Guidelines

**Background:**
- Solid color preferred (avoid gradients when possible)
- White background recommended
- Transparent backgrounds will not be accepted

**Logo/Design:**
- Clear and easy to read
- Professional appearance
- Brand-consistent (link to brand guidelines if available, e.g., [Google Pay](https://developers.google.com/pay/api/web/guides/brand-guidelines))

#### ✅ Border Requirements 

All icons **must have** a standard border for visual consistency.

**Option 1: Path-based border (recommended)**
```html
<path opacity=".07" d="M35 0H3C1.3 0 0 1.3 0 3v18c0 1.7 1.4 3 3 3h32c1.7 0 3-1.3 3-3V3c0-1.7-1.4-3-3-3z"/>
```

**Option 2: Rectangle-based border**
```html
<rect stroke="#000" stroke-opacity=".07" width="38" height="24" rx="2"/>
```

**Border style preferences (recommended but not enforced):**
- Opacity: `.07` (7%)
- Color: Black `#000` (or omit fill attribute, defaults to black)
- The border width must be 1px (pixel) thick.
- The border must have a 2px radius (outside stroke).

⚠️ **Missing borders will cause your PR to fail.** Wrong opacity/color will show warnings but won't block your PR.

---

## Template

Use this template as a starting point. Replace `{your-icon}` with your icon name:

```html
<svg xmlns="http://www.w3.org/2000/svg" role="img" viewBox="0 0 38 24" width="38" height="24" aria-labelledby="pi-{your-icon}">
    <title id="pi-{your-icon}">{Your icon}</title>
    <path fill="#000" opacity=".07" d="M35 0H3C1.3 0 0 1.3 0 3v18c0 1.7 1.4 3 3 3h32c1.7 0 3-1.3 3-3V3c0-1.7-1.4-3-3-3z"/>
    <path fill="#fff" d="M35 1c1.1 0 2 .9 2 2v18c0 1.1-.9 2-2 2H3c-1.1 0-2-.9-2-2V3c0-1.1.9-2 2-2h32"/>
</svg>
```

**This template includes:**
- ✅ All required attributes
- ✅ Proper accessibility markup
- ✅ Standard border (path with `.07` opacity)
- ✅ White background
- ✅ Correct dimensions and viewBox

---

## Validation Tests

Your icon will be checked against 20 automated tests:

### Standard Enforcement (16 tests)
These must pass for **all icons**:

1. ✅ Valid XML structure
2. ✅ Dimensions 38×24 pixels
3. ✅ ViewBox attribute exists
4. ✅ Accessibility requirements (title, role, aria-labelledby)
5. ✅ XML namespace present (`xmlns`)
6. ✅ No style tags
7. ✅ No class attributes
8. ✅ Vector graphics only
9. ✅ No embedded fonts
10. ✅ No external stylesheets
11. ✅ Single-line SVG format
12. ✅ Base64 PNG only (if raster images used)
13. ✅ Unique icon name
14. ✅ SVG file exists
15. ✅ Record is valid
16. ✅ Path returns correct format

### Selective Enforcement (4 tests)
New icons must pass, existing violations grandfathered:

17. 🎯 **Border validation** - Must have standard border (❌ fail if missing, ⚠️ warn if wrong style)
18. 🎯 **File size** - Must be under 15KB (10KB recommended)
19. 🎯 **ViewBox value** - Must be exactly `"0 0 38 24"`
20. 🎯 **Name validation** - No underscores/hyphens (NEW icons only, modified icons grandfathered)

**What this means for you:**
- **Adding a NEW icon?** Must pass all 20 tests
- **Modifying an EXISTING icon?** Must pass tests 1-19, test 20 (naming) is grandfathered
- **Other icons' violations?** Won't block your PR

---

## Common Issues

### ❌ "Icon name contains invalid characters"
**Problem:** Name has underscores or hyphens
**Fix:** Use `applePay` instead of `apple_pay`, or `visaCard` instead of `visa-card`

### ❌ "Icon is too large (18KB)"
**Problem:** File size exceeds 15KB limit
**Fix:** Run `svgo your-icon.svg` to optimize

### ❌ "Missing standard border"
**Problem:** No border element in SVG
**Fix:** Add border path from the [template](#template) before `</svg>`

### ❌ "Incorrect viewBox"
**Problem:** ViewBox is not `"0 0 38 24"`
**Fix:** Update `<svg>` tag: `viewBox="0 0 38 24"`

### ⚠️ "Border opacity should be .07"
**Warning only:** Won't block your PR, but recommended for consistency
**Fix:** Use `opacity=".07"` in your border element

---

## Need Help?

- 💬 Ask questions in your pull request
- 🐛 Report issues at [github.com/activemerchant/payment_icons/issues](https://github.com/activemerchant/payment_icons/issues)

---

*The trademarks and trade names provided in this library are those of their respective owners.*
