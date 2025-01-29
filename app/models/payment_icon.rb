require 'yaml'

class PaymentIcon < FrozenRecord::Base
  self.base_path = File.expand_path('../../db/', __dir__)

  GROUPS = {
    credit_cards: 'Credit cards',
    cryptocurrencies: 'Digital currencies',
    bank_transfers: 'Bank transfers',
    wallets: 'Digital wallets',
    convenience_stores: 'Convenience Stores',
    other: 'Other'
  }

  VARIANTS = %w[bordered unbordered dark].freeze

  # Icons are served via the Rail asset pipeline based on their file path in app/assets/images/payment_icons/
  def path
    "payment_icons/#{name}.svg"
  end

  # Add a new method to look up icons, considering both default icons and variants.
  # This method will not replace the existing behaviour but will serve as an enhancement to provide variant support
  def self.find_icon(name, variant = nil)
    icon = all.to_a.detect { |i| i['name'].casecmp(name).zero? }
    return nil unless icon

    raise ArgumentError, "Invalid variant: #{variant}" if variant && !VARIANTS.include?(variant)

    # If a variant is provided and exists, return the variant path
    if variant && icon['variants']&.key?(variant)
      path = "payment_icons/#{icon['variants'][variant]}.svg"
      return path if File.exist?(path)
    end

    # Fallback to default icon if variant is missing or not requested
    default_path = "payment_icons/#{name.downcase}.svg"
    default_path if File.exist?(default_path)
  end

  def self.find_by_group(group)
    where(group: group)
  end

  def self.credit_cards
    where(group: 'credit_cards')
  end

  def self.cryptocurrencies
    where(group: 'cryptocurrencies')
  end

  def self.bank_transfers
    where(group: 'bank_transfers')
  end

  def self.wallets
    where(group: 'wallets')
  end

  def self.convenience_stores
    where(group: 'convenience_stores')
  end
end
