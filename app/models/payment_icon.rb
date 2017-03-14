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

  def path
    "payment_icons/#{name}.svg"
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
